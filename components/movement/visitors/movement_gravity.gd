extends MovementVisitor
class_name MovementGravity

@export var strength: float = 1000

var is_falling = false

func visit_movement(me: Movement):
    match me.state:
        Movement.State.PROCESS:
            if not me.is_on_floor():
                me.velocity += Vector2(0, 1) * strength * me.dt
