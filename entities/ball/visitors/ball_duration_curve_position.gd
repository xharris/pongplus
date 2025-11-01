extends BallVisitor
class_name BallDurationCurvePosition

enum Type {ADD, SUB}

@export var type: Type
@export var amount: float = 0.05

func visit_ball(me: Ball):
    match type:
        Type.ADD:
            me.missile.duration_curve_position += amount
        Type.SUB:
            me.missile.duration_curve_position -= amount
