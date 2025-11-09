extends MissileVisitor
class_name MissilePathTo

enum Target {
    RANDOM_IN_GROUP,
    ALL_RANDOM_IN_GROUP,
    ALL_NONE,
}

var _log = Logger.new("ball_path_to")
@export var target: Target
## Group name to target
@export var group: StringName

func visit_missile(me: Missile):
    var missiles: Array[Missile] = [me]
    var platforms: Array[Platform]
    platforms.assign(me.get_tree().get_nodes_in_group(group))
    # get all balls?
    match target:
        Target.ALL_RANDOM_IN_GROUP, Target.ALL_NONE:
            missiles.assign(me.get_tree().get_nodes_in_group(Groups.MISSILE))
    # find next target
    match target:
        Target.ALL_NONE:
            for m in missiles:
                m.stop_pathing()
        
        Target.RANDOM_IN_GROUP, Target.ALL_RANDOM_IN_GROUP:
            # target a random platform
            for m in missiles:
                if platforms.size() > 0:
                    var target: Platform = platforms.pick_random()
                    m.path_to(target)
