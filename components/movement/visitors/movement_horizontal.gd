extends MovementVisitor
class_name MovementHorizontal

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
            velocity = lerp(velocity, me.move.x * speed, me.dt * acceleration)
            _velocity[me] = velocity
            # apply velocity
            me.velocity.x += velocity
            # speed limit
            me.velocity.x = clampf(me.velocity.x, -abs(speed), abs(speed))
            # apply friction
            if me.is_on_floor():
                me.velocity.x = lerpf(me.velocity.x, 0, me.dt * friction)
            else:
                me.velocity.x = lerpf(me.velocity.x, 0, me.dt * (friction/3))
