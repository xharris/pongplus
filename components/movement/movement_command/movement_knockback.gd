extends MovementCommand
class_name MovementKnockback

## Should be set before using Command.handle
var direction: Vector2
@export var strength: float
## Angle upwards to knockback (degrees)
@export var angle: float = 45
