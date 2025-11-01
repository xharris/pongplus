extends BallVisitor
class_name BallPosition

enum Position {ALL_CENTER}

var _log = Logger.new("ball_position")
@export var position: Position

func visit_ball(me: Ball):
    var balls: Array[Ball] = [me]
    match position:
        Position.ALL_CENTER:
            balls.assign(me.get_tree().get_nodes_in_group(Groups.BALL))
            
    match position:
        Position.ALL_CENTER:
            var view_size = me.get_viewport_rect()
            if me.is_inside_tree():
                for ball in balls:
                    ball.missile.stop_pathing()
                    ball.global_position = view_size.get_center()
                    _log.info("center %s at %v" % [ball, ball.global_position])
