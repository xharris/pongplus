extends Area2D
class_name Hitbox

const INDICATOR_AMOUNT_RATIO: float = 1.0

signal body_entered_once(body: Node2D)
signal accepted_visitor(v: Visitor)

@onready var particles: GPUParticles2D = $GPUParticles2D

@export var id: StringName
var _log = Logger.new("hitbox")
var _entered: Array[Node2D]

func accept(v: Visitor):
    if v is HitboxVisitor:
        v.visit_hitbox(self)
    else:
        accepted_visitor.emit(v)

func _ready() -> void:
    if id.length() == 0:
        _log.warn("id not set (%s)" % [get_path()])
    particles.amount_ratio = 0
    
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
    area_entered.connect(_on_body_entered)
    area_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
    _log.debug("body entered: %s" % [body])
    if not _entered.has(body):
        _entered.append(body)
        body_entered_once.emit(body)

func _on_body_exited(body: Node2D):
    _entered.erase(body)

func disable():
    for c in find_children("*"):
        if c is CollisionShape2D:
            c.disabled = true
            
func enable():
    for c in find_children("*"):
        if c is CollisionShape2D:
            c.disabled = false

func update_indicator(amount_ratio: float = INDICATOR_AMOUNT_RATIO):
    if particles.amount_ratio != amount_ratio:
        particles.amount_ratio = amount_ratio
        var particles_mat: ParticleProcessMaterial = particles.process_material
        if not particles_mat:
            _log.warn("no particle process material")
        else:
            for c in find_children("*"):
                if c is CollisionShape2D:
                    var shape = c.shape
                    if shape is CircleShape2D:
                        _log.debug("set particles radius: %d" % [shape.radius])
                        particles_mat.emission_ring_radius = shape.radius
                        particles_mat.emission_ring_inner_radius = shape.radius
                        
