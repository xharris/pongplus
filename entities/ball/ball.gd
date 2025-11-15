extends Node2D
class_name Ball

const SCENE = preload("res://entities/ball/ball.tscn")

@onready var missile: Missile = $Missile
@onready var hitbox: Hitbox = $Hitbox
@onready var sprite: Sprite2D = $Sprite2D

@export var abilities: Array[Ability]

var _log = Logger.new("ball")#, Logger.Level.DEBUG)
var next_missile_target: Node2D
var squeeze_amount = 0.5
var squeeze_duration = 1
var sprite_scale = 3
var _ability_ready_called: Array[StringName]

func accept(v: Visitor):
    if v is BallVisitor:
        v.visit_ball(self)
    elif v is MissileVisitor:
        missile.accept(v)
    elif v is HitboxVisitor:
        hitbox.accept(v)

func _ready() -> void:
    hide()
    add_to_group(Groups.BALL)
    EventBus.ball_created.emit.call_deferred(self)
    hitbox.accepted_visitor.connect(accept)
    hitbox.body_entered_once.connect(_on_body_entered_once)
    missile.started_path_to.connect(_on_missile_started_path_to)
    sprite.scale = Vector2(sprite_scale, sprite_scale)
    tree_exited.connect(_on_tree_exited)
    _update()
    show()
    _log.debug("created (%s)" % [get_instance_id()])
        
func _process(delta: float) -> void:
    _update()

func _on_tree_exited():
    EventBus.ball_destroyed.emit(self)
    _log.debug("left tree (%s)" % [get_instance_id()])

func _on_body_entered_once(body: Node2D):
    if body is Hitbox:
        match body.id:
            Hitboxes.PLAYER_PLATFORM:
                Ability.visit_abilities(abilities, self, Ability.ON_ME_HIT_PLAYER_PLATFORM)
                Ability.visit_abilities(abilities, body, Ability.ON_ME_HIT_PLAYER_PLATFORM)
            Hitboxes.PLAYER_HURTBOX:
                _log.debug("i hit player (%s)" % [get_instance_id()])
                Ability.visit_abilities(abilities, self, Ability.ON_ME_HIT_PLAYER)
                Ability.visit_abilities(abilities, body, Ability.ON_ME_HIT_PLAYER)

func _physics_process(_delta: float) -> void:
    if missile.is_pathing:
        global_position = missile.missile_position
    sprite.rotation = missile.velocity.angle()

func _on_missile_started_path_to(_target: Node2D):
    var tween = sprite.create_tween()
    tween.tween_property(sprite, "scale", Vector2(sprite_scale, sprite_scale), squeeze_duration)\
        .from(Vector2(sprite_scale+squeeze_amount, sprite_scale-squeeze_amount))

func _update():
    Ability.visit_abilities(abilities, self, Ability.ON_READY)
