extends Missile
class_name MagicMissile

@onready var hurtbox: Hitbox = %Hurtbox
@onready var hitbox: Hitbox = %Hitbox

var config: MagicMissileConfig

func accept(v: Visitor):
    if v is MagicMissileVisitor:
        v.visit_magic_missile(self)
    elif v is MissileVisitor:
        v.visit_missile(self)

func _ready() -> void:
    super._ready()
    if config:
        Visitor.visit(self, config.on_ready)

    hurtbox.accepted_visitor.connect(accept)
    hitbox.accepted_visitor.connect(accept)

func _on_hitbox_body_entered_once(body: Node2D):
    var other = body as Hitbox
    
    Visitor.visit(self, config.on_hit_visit_self)
    Visitor.visit(body, config.on_hit)
    # apply knockback
    _log.info("apply knockback")
    var knockback = MovementKnockback.new()
    knockback.direction = velocity.normalized()
    knockback.strength = config.knockback_strength
    Command.handle(body, knockback)
