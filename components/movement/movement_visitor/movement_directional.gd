extends MovementVisitor
class_name MovementDirectional

@export var speed: Vector2 =  Vector2(5000, 5000)
@export var acceleration: float = 100

func visit_movement(me: Movement):
    me.velocity = lerp(me.velocity, Vector2(me.move) * speed, me.dt * acceleration)
