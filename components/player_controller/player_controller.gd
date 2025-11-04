extends Controller
class_name PlayerController

## Seconds
const MAX_CHARGE_DURATION: float = 1

@export var config: PlayerControllerConfig
var is_charging: bool = false
var charge_duration: float = 0
## Seconds
var max_charge_duration: float = MAX_CHARGE_DURATION
var disable_charge_attack: bool = false

func _process(delta: float) -> void:
    if is_charging:
        charge_duration += delta
        if max_charge_duration > 0 and charge_duration >= max_charge_duration:
            # reached charge time limit
            release_attack.emit()
            is_charging = false

func _unhandled_input(event: InputEvent) -> void:
    if event.is_pressed():
        if config.up and event.is_match(config.up):
            up.emit()
        if config.down and event.is_match(config.down):
            down.emit()
        if not is_charging and not disable_charge_attack and config.attack and event.is_match(config.attack):
            charge_attack.emit()
            charge_duration = 0
            is_charging = true
    
    if event.is_released():
        if is_charging and config.attack and event.is_match(config.attack):
            release_attack.emit()
            is_charging = false
