extends MovementVisitor
class_name MovementOmnidirectional

@export var speed: float = 20
@export var acceleration: float = 20
@export var friction: float = 20
## Dict[Movement, Vector2]
var _velocity: Dictionary

func visit_movement(me: Movement):
    var speed_limit = Vector2(abs(speed), abs(speed))
    # apply friction
    me.velocity = lerp(me.velocity, Vector2.ZERO, me.dt * friction)
    # increase velocity
    me.velocity += me.move * speed * me.dt * acceleration
    # speed limit
    me.velocity = me.velocity.clamp(-speed_limit, speed_limit)
    # apply friction
    #me.velocity = lerp(me.velocity, Vector2.ZERO, me.dt * friction)
