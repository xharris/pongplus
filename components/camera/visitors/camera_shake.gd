extends CameraVisitor
class_name CameraShake

@export var amount: Vector2
@export var duration: float = 1.5

func visit_camera(me: Camera):
    me.shake(amount, duration)
