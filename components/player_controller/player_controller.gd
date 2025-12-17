extends Controller
class_name PlayerController

## Seconds
const MAX_CHARGE_DURATION: float = 1

var _log = Logger.new("player_controller", Logger.Level.DEBUG)

@export var config: PlayerControllerConfig
var is_charging: bool = false
var charge_duration: float = 0
## Seconds
var max_charge_duration: float = MAX_CHARGE_DURATION
var disable_charge_attack: bool = false
    
var _move_vectors: Dictionary = {
    "up":      Vector2(0, -1),
    "down":    Vector2(0, 1),
    "left":    Vector2(-1, 0),
    "right":   Vector2(1, 0),
}

func _is_key_pressed(event: InputEvent) -> bool:
    return event and Input.is_key_pressed(event.keycode if event is InputEventKey else KEY_NONE)

func _process(delta: float) -> void:
    # Reset move direction each frame
    move_direction = Vector2.ZERO
    
    # Read input and accumulate movement
    var up_pressed = config.up and _is_key_pressed(config.up)
    var down_pressed = config.down and _is_key_pressed(config.down)
    var left_pressed = config.left and _is_key_pressed(config.left)
    var right_pressed = config.right and _is_key_pressed(config.right)
    
    if up_pressed:
        move_direction.y -= 1
    if down_pressed:
        move_direction.y += 1
    if left_pressed:
        move_direction.x -= 1
    if right_pressed:
        move_direction.x += 1
    
    # Normalize diagonal movement to prevent faster diagonal speed
    if move_direction.length() > 1:
        move_direction = move_direction.normalized()
    
    # charge attack
    if is_charging:
        charge_duration += delta
        if max_charge_duration > 0 and charge_duration >= max_charge_duration:
            # reached charge time limit
            release_attack.emit()
            is_charging = false

    # Debug output
    if up_pressed or down_pressed or left_pressed or right_pressed:
        _log.debug("Keys: up=%s down=%s left=%s right=%s move=%v" % [up_pressed, down_pressed, left_pressed, right_pressed, move_direction])
    
func _unhandled_input(event: InputEvent) -> void:
    if event.is_pressed():
        var eventToSignal = {
            config.up: up,
            config.down: down,
            config.left: left,
            config.right: right,
        }
        for e: InputEvent in eventToSignal:
            var sig: Signal = eventToSignal[e]
            if e and sig and event.is_match(e):
                sig.emit()
            
        if not is_charging and not disable_charge_attack and config.attack and event.is_match(config.attack):
            charge_attack.emit()
            charge_duration = 0
            is_charging = true
    
    if event.is_released():
        if is_charging and config.attack and event.is_match(config.attack):
            release_attack.emit()
            is_charging = false
