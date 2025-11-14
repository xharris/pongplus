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

func visit_missile(me: Missile):
    var missiles: Array[Missile] = [me]
    var targets: Array[Node2D]
    targets.assign(me.get_tree().get_nodes_in_group(group))
    # find next target
    match target:
        Type.NONE:
            # JUST STOP
            me.stop_pathing()
        
        Type.RANDOM_IN_GROUP:
            # pick random target
            if targets.size() > 0:
                var target: Node2D = targets.pick_random()
                me.path_to(target)
