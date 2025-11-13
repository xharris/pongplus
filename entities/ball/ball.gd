extends Node2D
class_name Ball

const SCENE = preload("res://entities/ball/ball.tscn")

@onready var missile: Missile = $Missile
@onready var hitbox: Hitbox = $Hitbox
@onready var sprite: Sprite2D = $Sprite2D

@export var abilities: Array[Ability]

var next_missile_target: Node2D
var squeeze_amount = 0.5
var squeeze_duration = 1
var sprite_scale = 3

func accept(v: Visitor):
    if v is BallVisitor:
        v.visit_ball(self)
    elif v is MissileVisitor:
        missile.accept(v)
    elif v is HitboxVisitor:
        hitbox.accept(v)

func _ready() -> void:
    add_to_group(Groups.BALL)
    EventBus.ball_created.emit.call_deferred(self)
    hitbox.accepted_visitor.connect(accept)
    hitbox.body_entered_once.connect(_on_body_entered_once)
    missile.start_path_to.connect(_on_missile_start_path_to)
    sprite.scale = Vector2(sprite_scale, sprite_scale)
    for a in abilities:
        Visitor.visit(self, a.on_ready)

func _on_body_entered_once(body: Node2D):
    if body is Hitbox:
        match body.id:
            Hitboxes.PLAYER_PLATFORM:
                # BUG not being called?
                for a in abilities:
                    Visitor.visit(self, a.on_me_hit_player_platform)
                    Visitor.visit(body, a.on_me_hit_player_platform)
            Hitboxes.PLAYER_HURTBOX:
                for a in abilities:
                    Visitor.visit(self, a.on_me_hit_player)
                    Visitor.visit(body, a.on_me_hit_player)

func _physics_process(_delta: float) -> void:
    if missile.is_pathing:
        global_position = missile.missile_position
    sprite.rotation = missile.velocity.angle()

func _on_missile_start_path_to():
    var tween = sprite.create_tween()
    tween.tween_property(sprite, "scale", Vector2(sprite_scale, sprite_scale), squeeze_duration)\
        .from(Vector2(sprite_scale+squeeze_amount, sprite_scale-squeeze_amount))

func add_ability(ability: Ability):
    abilities.append(ability)
    Visitor.visit(self, ability.on_ready)
