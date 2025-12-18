extends Missile
class_name MagicMissile

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
