extends MissileVisitor
class_name MissileDurationCurvePosition

enum Type {ADD, SUB}

@export var type: Type
@export var amount: float = 0.05

func visit_missile(me: Missile):
    match type:
        Type.ADD:
            me.duration_curve_position += amount
        Type.SUB:
            me.duration_curve_position -= amount
