extends Resource
class_name Gameplay

@export var name: StringName

@export var on_start: Array[Visitor]
@export var on_player_spawn: Array[Visitor]
@export var on_player_take_damage: Array[Visitor]
#@export var on_ball_destroyed: Array[Visitor]
@export var on_exit: Array[Visitor]
