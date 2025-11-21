@tool
extends Node2D
class_name VfxSpeedy

@onready var animation: AnimationPlayer = $AnimationPlayer

var node: Node2D

func _ready() -> void:
    if Engine.is_editor_hint():
        node = $TestSprite2D  
    else:
        node = get_parent()
        remove_child($TestSprite2D)  

func _process(delta: float) -> void:
    if Engine.is_editor_hint():
        # move back and forth (sine)
        pass
