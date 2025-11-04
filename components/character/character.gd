extends Node2D
class_name Character

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Node2D = %Sprite

func charge_attack():
    animation_player.stop(true)
    animation_player.play("attack")
    animation_player.advance(0)
    animation_player.pause()

func attack():
    animation_player.play("attack")

func is_attacking():
    return animation_player.is_playing() and animation_player.current_animation == "attack"

func face_right():
    sprite.scale.x = 1
    
func face_left():
    sprite.scale.x = -1
