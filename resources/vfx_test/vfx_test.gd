@tool
extends Node2D

@onready var vfx_speedy: VfxSpeedy = $VfxSpeedy

var _t: float = 0
var _sin_t: float = 0
var _sin_speed: float = 0

func _process(delta: float) -> void:
    _t += delta
    _sin_speed = pingpong(_t, 10)
    _sin_t += delta * _sin_speed
    #print(pingpong(_t, 10))
    vfx_speedy.global_position.x = sin(_sin_t) * 200
    
