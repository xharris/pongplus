extends Node2D
class_name Controller

var _log = Logger.new("controller")#, Logger.Level.DEBUG)
@export var max_charge_duration: float = 2
@export var counter_duration: float = 0.5
var is_charging: bool = false
var is_blocking: bool = false
var is_countering: bool:
    get:
        return is_blocking and block_duration <= counter_duration
## normal vector of direction to move (ie. joystick movement)
var move_direction: Vector2
var charge_duration: float
var block_duration: float

signal up
signal down
signal left
signal right
## charging up attack
signal attack_charge
## release attack
signal attack_release
signal block_start
signal block_stop
## next ability
signal next

func _ready() -> void:
    attack_charge.connect(_on_attack_charge)
    attack_release.connect(_on_attack_release)
    block_start.connect(_on_block_start)
    block_stop.connect(_on_block_stop)

func _on_block_start():
    _log.debug("block start")
    is_blocking = true
    block_duration = 0

func _on_block_stop():
    _log.debug("block stop")
    is_blocking = false
    block_duration = 0

func _on_attack_charge():
    _log.debug("attack charge")
    is_charging = true
    charge_duration = 0

func _on_attack_release():
    _log.debug("attack release")
    is_charging = false

func _process(delta: float) -> void:
    if is_charging:
        charge_duration += delta
        # auto-release at charge time limit
        if charge_duration >= max_charge_duration:
            attack_release.emit()
    if is_blocking:
        block_duration += delta
