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
    hitbox.body_entered_once.connect(_on_hitbox_body_entered_once)

func _on_hitbox_body_entered_once(body: Node2D):
    var my_team = Groups.get_team(self)
    var other_team = Groups.get_team(body)
    if my_team == other_team:
        return
    Visitor.visit(self, config.on_hit_visit_self)
    Visitor.visit(body, config.on_hit)
    for c in config.on_hit_commands:
        if c is MovementKnockback:
            c = c.duplicate()
            c.direction = velocity.normalized()
        Command.handle(body, c)
    # destroy self?
    
