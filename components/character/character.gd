extends Node2D
class_name Character

signal attack_window_start
signal attack_window_end

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Node2D = %Sprite
@onready var weapon: Node2D = %Weapon

var _log = Logger.new("character")
var _attack_window_active: bool = false
var _attack_window_ended: bool = false
var attack_window_active: bool:
    get: return _attack_window_active
var attack_window_ended: bool:
    get: return _attack_window_ended

func charge_attack():
    animation_player.stop(true)
    animation_player.play("attack")
    animation_player.advance(0)
    animation_player.pause()

func attack():
    animation_player.play("attack")

func _attack_window_start():
    _attack_window_active = true
    _attack_window_ended = false
    attack_window_start.emit()
    
func _attack_window_end():
    _attack_window_active = false
    _attack_window_ended = true
    attack_window_end.emit()

func is_attacking():
    return animation_player.is_playing() and animation_player.current_animation == "attack"

func face_right():
    sprite.scale.x = 1
    
func face_left():
    sprite.scale.x = -1

func set_weapon_color(color: Color = Color.WHITE, value: float = 0):
    var material: ShaderMaterial = weapon.material
    material.set_shader_parameter("flash_color", color)
    material.set_shader_parameter("flash_value", value)
