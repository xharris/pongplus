extends Resource
class_name BallMissileTargetStrategy

enum AimDirection {STRAIGHT, UP, DOWN}

var _log = Logger.new("ball_target_platform")#, Logger.Level.DEBUG)
var direction: AimDirection

func get_next_target(me: Missile) -> Node2D:
    # get last platform targeted
    var targets = me.target_history.duplicate()
    targets.reverse()
    var platform: Platform
    for t in targets:
        var p: Platform = Util.get_ancestor(t, Platform)
        if p:
            platform = p
            break
    if not platform:
        _log.warn(
            "no previously targeted platform:\n\tmissile.target_history: %s" % [
                me.target_history
            ])
        return
    # get same index platform in group
    var last_group = NodeGroup.get_group(platform)
    if not last_group:
        _log.warn("platform is not part of a group: %s" % [platform])
        return
    var groups: Array[NodeGroup]
    groups.assign(me.get_tree().get_nodes_in_group(Groups.NODE_GROUP))
    groups.erase(last_group)        
    var group: NodeGroup = groups.pick_random()
    var index_in_group = last_group.find(platform)
    # get next platform to target
    var next_missile_target: Node2D
    match direction:
        AimDirection.UP:
            index_in_group -= 1
        AimDirection.DOWN:
            index_in_group += 1
    var item = group.items[clampi(index_in_group, 0, group.items.size()-1)]
    var next_platform = item.find_child('Platform')
    next_missile_target = next_platform
    # move to it
    _log.debug("Ball next target: from %s to %s" % [platform, next_missile_target])
    return next_missile_target
