extends BallVisitor
class_name BallPosition

enum Position {CENTER}

var _log = Logger.new("ball_position")#, Logger.Level.DEBUG)
@export var position: Position

func visit_ball(me: Ball):
    match position:
        Position.CENTER:
            var view_size = me.get_viewport_rect()
            me.missile.stop_pathing()
            me.global_position = view_size.get_center()
            _log.debug("center %s at %v" % [me, me.global_position])
