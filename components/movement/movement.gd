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
        state = State.ACCEPT
        v.visit_movement(self)
    else:
        state = State.ACCEPT
        accepted_visitor.emit(v)

func _process(delta: float) -> void:
    state = State.PROCESS
    dt = delta
    Visitor.visit(self, visitors)
