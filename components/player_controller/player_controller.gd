extends Controller
class_name PlayerController

@export var config: PlayerControllerConfig

func _init() -> void:
    _log.set_id("player_controller")

func _process(delta: float) -> void:
    super._process(delta)
    if not config:
        return
    move_direction = Input.get_vector(
        "left", "right", "up", "down"
    )

func _unhandled_input(event: InputEvent) -> void:
    if not config:
        return
    if event.device != config.device:
        return
        
    if event.is_action_pressed("attack"):
        attack_charge.emit()
    if event.is_action_released("attack"):
        attack_release.emit()
        
    if event.is_action_pressed("block"):
        block_start.emit()
    if event.is_action_released("block"):
        block_stop.emit()
        
    if event.is_action("jump"):
        up.emit()
