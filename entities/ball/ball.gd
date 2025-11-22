extends Node2D
class_name Ball

const SCENE = preload("res://entities/ball/ball.tscn")
## Used for ball name
static var _i = 0

@onready var missile: Missile = %Missile
## Um, akshually it's a hurtbox
@onready var hitbox: Hitbox = %Hitbox
@onready var sprite: Sprite2D = %Sprite2D
@onready var sprite_container: Node2D = %SpriteContainer
@onready var camera: Camera = %Camera
@onready var vfx_impact: VfxImpact = %VfxImpact

@export var abilities: Array[Ability]

var _log = Logger.new("ball")#, Logger.Level.DEBUG)
var next_missile_target: Node2D
var squeeze_amount = 0.5
var squeeze_duration = 1
var _ability_ready_called: Array[StringName]

func accept(v: Visitor):
    if v is BallVisitor:
        v.visit_ball(self)
    elif v is MissileVisitor:
        missile.accept(v)
    elif v is HitboxVisitor:
        hitbox.accept(v)
    elif v is CameraVisitor:
        camera.accept(v)
    elif v is VfxImpactVisitor:
        vfx_impact.accept(v)

func _ready() -> void:
    name = "Ball%d" % [_i]
    _i += 1
    _log.set_id(name)
    hide()
    add_to_group(Groups.BALL)
    
    EventBus.ball_created.emit.call_deferred(self)
    hitbox.accepted_visitor.connect(accept)
    hitbox.body_entered_once.connect(_on_body_entered_once)
    tree_exited.connect(_on_tree_exited)
    
    _update()
    show()
    _log.debug("created (%s)" % [get_instance_id()])
        
func _process(delta: float) -> void:
    if is_visible_in_tree():
        _update()
        if missile.tween:
            missile.tween.set_speed_scale(Camera.avg_time_scale)

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
    sprite_container.rotation = missile.velocity.angle()

func _update():
    missile._log.set_prefix(name)
    hitbox._log.set_prefix(name)
    Ability.visit_abilities(abilities, self, Ability.ON_READY)
