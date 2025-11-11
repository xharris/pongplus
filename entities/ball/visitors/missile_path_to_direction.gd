## Will target a node in the given [code]target_group[/code] but in a different
## NodeGroup.
extends MissileVisitor
class_name MissilePathToDirection

enum AimDirection {STRAIGHT, UP, DOWN, RANDOM}

var _log = Logger.new("ball_missile_path_to", Logger.Level.DEBUG)
@export var direction: AimDirection
@export var target_group: StringName
@export var target_filter_strategy: FilterStrategy
@export var avoid_repeat: bool = true
@export var different_node_group: bool = true

## Get last target in the same target_group
func _get_last_target(me: Missile) -> Node2D:
    var history = me.target_history.duplicate()
    history.reverse() # newest to oldest
    for t in history:
        if t.is_in_group(target_group):
            return t
    return

func visit_missile(me: Missile):
    var items: Array[Node2D]
    items.assign(me.get_tree().get_nodes_in_group(target_group))
    # filter: avoid targeting same node
    if avoid_repeat:
        var last_target_same_group = _get_last_target(me)
        if last_target_same_group:
            items.erase(last_target_same_group)
    # filter: only target in different NodeGroup
    if different_node_group:
        var last_target = _get_last_target(me)
        if last_target:
            var last_group = NodeGroup.get_group(last_target)
            # get all groups that are not the last one
            var other_groups: Array[NodeGroup]
            for item in items:
                var group = NodeGroup.get_group(item)
                if group and group != last_group and not other_groups.has(group):
                    other_groups.append(group)
            if other_groups.size() > 0:
                # only use items that belong to randomly picked group
                var group: NodeGroup = other_groups.pick_random()
                _log.debug("pick group %s -> %s" % [last_group, group])
                items = items.filter(func(item: Node2D):
                    return group.find(item) >= 0)
    # filter: use filter strategy
    if target_filter_strategy:
        items = items.filter(target_filter_strategy.filter)
    if items.size() == 0:
        _log.error(items.size() == 0, "no targets")
        me.stop_pathing()
        return
    # use aim direction
    var index: int
    var last_target_same_group = _get_last_target(me)
    if last_target_same_group:
        var last_group = NodeGroup.get_group(last_target_same_group)
        if last_group:
            index = last_group.find(last_target_same_group)
    match direction:
        AimDirection.UP:
            index -= 1
        AimDirection.DOWN:
            index += 1
        AimDirection.RANDOM:
            index = randi() % items.size()
    index = clampi(index, 0, items.size()-1)
    # finally, path to it
    var next_target = items[index]
    _log.debug("set target: from %s to %s" % [me.target_history.back(), next_target])
    me.path_to(next_target)
