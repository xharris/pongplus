extends Controller
class_name PlayerController

@export var config: PlayerControllerConfig
var is_charging: bool = false
var charge_duration: float = 0

func _process(delta: float) -> void:
    if is_charging:
        charge_duration += delta

func _unhandled_input(event: InputEvent) -> void:
    if event.is_pressed():
        if config.up and event.is_match(config.up):
            up.emit()
        if config.down and event.is_match(config.down):
            down.emit()
        if config.attack and event.is_match(config.attack):
            charge_attack.emit()
            charge_duration = 0
            is_charging = true
    
    if event.is_released():
        if is_charging and config.attack and event.is_match(config.attack):
            release_attack.emit()
            is_charging = false
