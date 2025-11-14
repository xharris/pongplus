extends GameVisitor
class_name BallPositionAll

enum Position {CENTER}

var _log = Logger.new("ball_position_all")#, Logger.Level.DEBUG)
@export var position: Position

func visit_game(me: Game):
    var balls: Array[Ball]
    balls.assign(me.get_tree().get_nodes_in_group(Groups.BALL))

    match position:
        Position.CENTER:
            var view_size = me.get_viewport_rect()
            for ball in balls:
                ball.missile.stop_pathing()
                ball.global_position = view_size.get_center()
                _log.debug("center %s at %v" % [ball, ball.global_position])
