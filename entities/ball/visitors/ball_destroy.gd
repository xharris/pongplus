extends BallVisitor
class_name BallDestroy

func visit_ball(me: Ball):
    var parent = me.get_parent()
    if parent:
        EventBus.ball_destroyed.emit(me)
        parent.remove_child(me)
