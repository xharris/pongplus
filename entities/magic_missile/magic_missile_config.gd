extends Resource
class_name MagicMissileConfig

@export var on_ready: Array[Visitor]
## Visitors to run on body when this missile hits it
@export var on_hit: Array[Visitor]
## Visitors to run on this missile when it hits a body
@export var on_hit_visit_self: Array[Visitor]
## Commands to run on the body that is hit by this missile
@export var on_hit_commands: Array[Command]
