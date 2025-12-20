extends Controller
class_name PlayerController

var _log = Logger.new("player_controller")#, Logger.Level.DEBUG)

@export var config: PlayerControllerConfig
    
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

    # Debug output
    _log.debug("Keys: up=%s down=%s left=%s right=%s move=%v" % [up_pressed, down_pressed, left_pressed, right_pressed, move_direction])
    
func _unhandled_input(event: InputEvent) -> void:
    if event.is_pressed():
        var eventToSignal = {
            config.up: up,
            config.down: down,
            config.left: left,
            config.right: right,
        }
        # 4 direction movement
        for e: InputEvent in eventToSignal:
            var sig: Signal = eventToSignal[e]
            if e and sig and event.is_match(e):
                sig.emit()
        # charge attack
        if not is_charging and config.attack and event.is_match(config.attack):
            attack_charge.emit()
        # block
        if not is_blocking and config.block and event.is_match(config.block):
            block_start.emit()
    
    if event.is_released():
        if is_charging and config.attack and event.is_match(config.attack):
            attack_release.emit()
        if is_blocking and config.block and event.is_match(config.block):
            block_stop.emit()
