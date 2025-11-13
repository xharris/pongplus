extends Node2D
class_name Health

signal died
signal current_changed(amount: int)

@export var max: int
var _current: int

func accept(v: Visitor):
    if v is HealthVisitor:
        v.visit_health(self)

func _ready() -> void:
    _current = max

func take_damage(amount: int):
    amount = -abs(amount)
    _current += amount
    _current = max(0, _current)
    current_changed.emit(amount)
    if _current <= 0:
        died.emit()

func is_alive() -> bool:
    return _current > 0
