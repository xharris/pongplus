extends CharacterBody2D
class_name Movement

enum State {ACCEPT, PROCESS}

signal accepted_visitor(v: Visitor)

var _log = Logger.new("movement")
var state: Movement.State
var dt: float
var move: Vector2
var is_falling: bool:
    get:
        return velocity.y > 0 and not is_on_floor()

## Call visitors in process
@export var visitors: Array[Visitor]

func accept(v: Visitor):
    if v is MovementVisitor:
        v.visit_movement(self)
    else:
        accepted_visitor.emit(v)

func handle(cmd: Command):
    if cmd is MovementKnockback:
        var strength = cmd.strength_curve.sample(cmd.strength)
        _log.info("knocked back: %s, strength: %f -> %f" % [cmd.direction, cmd.strength, strength])
        var dir = Vector2(sign(cmd.direction.x), 0) * strength
        dir = dir.rotated(-deg_to_rad(cmd.angle) * sign(dir.x))
        velocity += dir

func _process(delta: float) -> void:
    dt = delta
    state = Movement.State.PROCESS
    Visitor.visit(self, visitors)
    state = Movement.State.ACCEPT
    move_and_slide()
