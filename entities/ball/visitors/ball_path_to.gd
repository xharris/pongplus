extends BallVisitor
class_name BallPathTo

enum Target {
    RANDOM_PLATFORM,
    ALL_RANDOM_PLATFORM,
    ALL_NONE,
}

var _log = Logger.new("ball_path_to")
@export var target: Target

func visit_ball(me: Ball):
    var balls: Array[Ball] = [me]
    var platforms: Array[Platform]
    platforms.assign(me.get_tree().get_nodes_in_group(Groups.PLATFORM))
    # get all balls?
    match target:
        Target.ALL_RANDOM_PLATFORM, Target.ALL_NONE:
            balls.assign(me.get_tree().get_nodes_in_group(Groups.BALL))
    # find next target
    match target:
        Target.ALL_NONE:
            for ball in balls:
                ball.missile.stop_pathing()
        
        Target.RANDOM_PLATFORM, Target.ALL_RANDOM_PLATFORM:
            # target a random platform
            for ball in balls:
                if platforms.size() > 0:
                    var target: Platform = platforms.pick_random()
                    ball.missile.path_to(target)
