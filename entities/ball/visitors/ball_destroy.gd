extends BallVisitor
class_name BallDestroy

func visit_ball(me: Ball):
    Util.destroy_free(me)
