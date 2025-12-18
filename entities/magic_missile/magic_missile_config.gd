extends Resource
class_name MagicMissileConfig

@export var on_ready: Array[Visitor]
## Hitbox hits a Hurtbox
@export var on_hit: Array[Visitor]
## Hitbox hits a Hurtbox, but apply visitors to me
@export var on_hit_visit_self: Array[Visitor]

@export var knockback_strength: float = 3
