extends MissileVisitor
class_name MissilePathTo

enum Type {
    ## BUG targets platforms in same PositionStrategy. how to fix this?
    RANDOM_IN_GROUP,
    ALL_RANDOM_IN_GROUP,
    ALL_NONE,
}

var _log = Logger.new("missile_path_to")
@export var target: Type
## Group name to target
@export var group: StringName

func visit_missile(me: Missile):
    var missiles: Array[Missile] = [me]
    var targets: Array[Node2D]
    targets.assign(me.get_tree().get_nodes_in_group(group))
    # get all balls?
    match target:
        Type.ALL_RANDOM_IN_GROUP, Type.ALL_NONE:
            missiles.assign(me.get_tree().get_nodes_in_group(Groups.MISSILE))
    # find next target
    match target:
        Type.ALL_NONE:
            # just STOP
            for m in missiles:
                m.stop_pathing()
        
        Type.RANDOM_IN_GROUP, Type.ALL_RANDOM_IN_GROUP:
            # pick random target
            for m in missiles:
                if targets.size() > 0:
                    var target: Node2D = targets.pick_random()
                    m.path_to(target)
