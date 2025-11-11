extends Node2D
class_name Game

func _ready() -> void:
    add_to_group(Groups.GAME)

func _process(delta: float) -> void:
    Camera.update_view(delta)
    
