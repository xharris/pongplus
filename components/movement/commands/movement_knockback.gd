extends MovementCommand
class_name MovementKnockback

## Should be set before using Command.handle
var direction: Vector2
@export_range(0, 1, 0.1) var strength: float
## Angle upwards to knockback (degrees)
@export var angle: float = 45
@export var strength_curve: Curve = preload("res://resources/knockback_strength.tres")
