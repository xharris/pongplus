extends Node2D
class_name Ball

const SCENE = preload("res://entities/ball/ball.tscn")

@onready var missile: Missile = $Missile
@onready var hitbox: Hitbox = $Hitbox
@onready var sprite: Sprite2D = $Sprite2D

@export var on_ready: Array[Visitor]
var next_missile_target: Node2D
var squeeze_amount = 0.5
var squeeze_duration = 1
var sprite_scale = 3

func accept(v: Visitor):
    if v is BallVisitor:
        v.visit_ball(self)
    else:
        missile.accept(v)

func _ready() -> void:
    add_to_group(Groups.BALL)
    sprite.scale = Vector2(sprite_scale, sprite_scale)
    Visitor.visit(self, on_ready)

func _physics_process(_delta: float) -> void:
    if missile.is_pathing:
        global_position = missile.missile_position
    sprite.rotation = missile.velocity.angle()

func missile_path_next_target():
    if next_missile_target:
        missile.path_to(next_missile_target)
        var tween = sprite.create_tween()
        tween.tween_property(sprite, "scale", Vector2(sprite_scale, sprite_scale), squeeze_duration)\
            .from(Vector2(sprite_scale+squeeze_amount, sprite_scale-squeeze_amount))
