@tool
extends Node2D
class_name VfxSpeedy

@onready var animation: AnimationPlayer = $AnimationPlayer

@export var config: VfxSpeedyConfig
var _last_position: Vector2
var _velocity: Vector2

func _ready() -> void:
    _last_position = global_position
    if not Engine.is_editor_hint():
        Util.destroy_free(animation)

func _process(delta: float) -> void:
    if Engine.is_editor_hint() and not config:
        config = VfxSpeedyConfig.new()
    if Engine.is_editor_hint() or (_last_position != Vector2.ZERO and global_position != Vector2.ZERO):
        # calculate velocity
        _velocity = (_last_position - global_position)
        # squeeze based on velocity
        var velocity_amt: float = Util.diminishing(_velocity.length(), config.squeeze_rate_of_change)
        scale =  lerp(
            Vector2.ONE, Vector2(config.squeeze_amount, 1/config.squeeze_amount), 
            velocity_amt
        )
    _last_position = global_position
        
