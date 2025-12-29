extends MovementVisitor
class_name MovementVertical

@export var speed: float
@export var acceleration: float = 2
@export var friction: float = 0
## Dict[Movement, Vector2]
var _velocity: Dictionary

func visit_movement(me: Movement):
    match me.state:
        Movement.State.PROCESS:
            # calculate velocity
            var velocity: float = _velocity.get(me, 0)
            velocity = lerp(velocity, me.move.y * speed, me.dt * acceleration)
            _velocity[me] = velocity
            # apply velocity
            me.velocity.y += velocity
            # speed limit
            me.velocity.y = clampf(me.velocity.y, -abs(speed), abs(speed))
            # apply friction
            if me.is_on_floor():
                me.velocity.y = lerpf(me.velocity.y, 0, me.dt * friction)
            else:
                me.velocity.y = lerpf(me.velocity.y, 0, me.dt * (friction/3))
