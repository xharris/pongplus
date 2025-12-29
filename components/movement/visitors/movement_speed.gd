extends MovementVisitor
class_name MovementSpeed

@export_range(0, 1, 0.1) var amount: float
@export var curve: Curve = preload("res://resources/missile_speed.tres")

func visit_movement(me: Movement):
    me.velocity = me.velocity.normalized() * curve.samplef(amount)
