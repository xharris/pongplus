extends MissileVisitor
class_name MissilePathTo

enum Type {
    RANDOM_IN_GROUP,
    NONE,
}

var _log = Logger.new("missile_path_to")
@export var target: Type
## Group name to target
@export var group: StringName
@export var target_strategy: TargetStrategy

func visit_missile(me: Missile):
    var missiles: Array[Missile] = [me]
    var targets: Array[Node2D]
    targets.assign(me.get_tree().get_nodes_in_group(group))
    var target_node: Node2D
    if target_strategy:
        # use target strategy
        target_node = target_strategy.get_target(me)
    else:
        # find next target
        match target:
            Type.NONE:
                # JUST STOP
                me.stop_pathing()
            
            Type.RANDOM_IN_GROUP:
                # pick random target
                if targets.size() > 0:
                    target_node = targets.pick_random()
    # go
    if target_node:
        me.path_to(target_node)
