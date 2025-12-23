extends CharacterBody2D
class_name Missile

signal started_path_to(target: Node2D)

@export var speed_curve: Curve = preload("res://resources/missile_speed.tres")
@export var speed: float = 0:
    set(v):
        speed = clampf(v, 0, 1)
        # update speed
        velocity = velocity.normalized() * speed_curve.sample(speed)

var _log = Logger.new("missile", Logger.Level.DEBUG)
var target_history: Array[Node2D]

func accept(v: Visitor):
    if v is MissileVisitor:
        v.visit_missile(self)

func _process(delta: float) -> void:
    move_and_slide()
    
func _ready() -> void:
    add_to_group(Groups.MISSILE)
          
func path_to(target: Node2D):
    if not target:
        _log.warn("path to null target (%s)" % [self])
        return
    velocity = \
        global_position.direction_to(target.global_position).normalized()\
        * speed_curve.sample(speed)
    _log.info("path, velocity: %v" % [velocity])
    started_path_to.emit(target)

func stop_pathing():
    velocity = Vector2.ZERO
