extends MovementCommand
class_name MovementKnockback

enum Strength {WEAK, STRONG}

## Should be set before using Command.handle
var direction: Vector2
@export var strength: Strength
