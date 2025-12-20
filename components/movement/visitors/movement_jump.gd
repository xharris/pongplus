extends MovementVisitor
class_name MovementJump

@export var velocity: float = 0
@export var must_be_on_floor: bool = true

func visit_movement(me: Movement):
    match me.state:
        Movement.State.ACCEPT:
            if me.is_on_floor() or not must_be_on_floor:
                me.velocity.y = -abs(velocity)
