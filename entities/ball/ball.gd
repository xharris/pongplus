extends Node2D
class_name Ball

@onready var missile: Missile = $Missile
@onready var hitbox: Hitbox = $Hitbox



func accept(visitor: Visitor):
    if visitor is BallVisitor:
        visitor.visit_ball(self)

func _ready() -> void:
    # target a random missile target
    var targets: Array[MissileTarget]
    targets.assign(get_tree().get_nodes_in_group(Groups.MISSILE_TARGET))
    if targets.size() > 0:
        var target: MissileTarget = targets.pick_random()
        missile.path_to(target)

func _physics_process(_delta: float) -> void:
    global_position = missile.missile_position
