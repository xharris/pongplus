extends Node2D
class_name Ball

const SCENE = preload("res://entities/ball/ball.tscn")

@onready var missile: Missile = $Missile
@onready var hitbox: Hitbox = $Hitbox

@export var on_ready: Array[Visitor]
var next_missile_target: Node2D

func accept(visitor: Visitor):
    if visitor is BallVisitor:
        visitor.visit_ball(self)

func _ready() -> void:
    add_to_group(Groups.BALL)
    Visitor.visit(self, on_ready)

func _physics_process(_delta: float) -> void:
    if missile.is_pathing:
        global_position = missile.missile_position

func missile_path_next_target():
    if next_missile_target:
        missile.path_to(next_missile_target)
