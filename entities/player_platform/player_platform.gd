extends Node2D
class_name PlayerPlatform

@onready var platform: Platform = $Platform
@onready var hitbox: Hitbox = $Hitbox

func accept(v: Visitor):
    if v is PlatformVisitor:
        platform.accept(v)
    elif v is HitboxVisitor:
        hitbox.accept(v)
    
func _ready() -> void:
    hitbox.accepted_visitor.connect(accept)
