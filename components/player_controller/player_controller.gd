extends Controller
class_name PlayerController

@export var config: PlayerControllerConfig
var _charging: bool = false

func _unhandled_input(event: InputEvent) -> void:
    if event.is_pressed():
        if config.up and event.is_match(config.up):
            up.emit()
        if config.down and event.is_match(config.down):
            down.emit()
        if config.attack and event.is_match(config.attack):
            charge_attack.emit()
            _charging = true
    
    if event.is_released():
        if _charging and config.attack and event.is_match(config.attack):
            release_attack.emit()
            _charging = false
