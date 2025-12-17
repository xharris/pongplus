extends Node2D
class_name MagicMissile

@onready var missile: Missile = %Missile

func accept(v: Visitor):
    if v is MagicMissileVisitor:
        v.visit_magic_missile(self)

func _ready() -> void:
    pass
