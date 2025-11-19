extends Node2D
class_name Health

signal died
signal current_changed(amount: int)

var _log = Logger.new("health")#, Logger.Level.DEBUG)
@export var max: int
@export var invincible: bool:
    set(v):
        if invincible != v:
            _log.debug("invincible: %s" % [v])
        invincible = v
var _current: int

func accept(v: Visitor):
    if v is HealthVisitor:
        v.visit_health(self)

func _ready() -> void:
    _current = max

func take_damage(amount: int):
    amount = -abs(amount)
    if invincible:
        return
    _current += amount
    _current = max(0, _current)
    _log.debug("took damage: %d" % [amount])
    current_changed.emit(amount)
    if _current <= 0:
        died.emit()

func is_alive() -> bool:
    return _current > 0
