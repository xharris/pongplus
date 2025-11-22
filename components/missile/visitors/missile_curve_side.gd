extends MissileVisitor
class_name MissileCurveSide

@export var value: Missile.CurveSide

func visit_missile(me: Missile):
    me.curve_side = value
