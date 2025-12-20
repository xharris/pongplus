extends Node2D
class_name Controller

var is_charging: bool = false
var is_blocking: bool = false

## normal vector of direction to move (ie. joystick movement)
var move_direction: Vector2

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

func _ready() -> void:
    attack_charge.connect(_on_attack_charge)
    attack_release.connect(_on_attack_release)
    block_start.connect(_on_block_start)
    block_stop.connect(_on_block_stop)
    
func _on_block_start():
    is_blocking = true
    
func _on_block_stop():
    is_blocking = false
    
func _on_attack_charge():
    is_charging = true
    
func _on_attack_release():
    is_charging = false
