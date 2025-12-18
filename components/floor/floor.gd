extends StaticBody2D
class_name Floor

@export var layer: HitboxLayer

var _log = Logger.new("floor")

func _ready() -> void:
    if layer:
        layer.update(self)
