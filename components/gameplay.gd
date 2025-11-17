extends Resource
class_name Gameplay

@export var name: StringName

@export var ball_abilities: Array[Ability]
@export var player_abilties: Array[Ability]

@export var on_start: Array[Visitor]
@export var on_player_take_damage: Array[Visitor]
@export var on_ball_destroyed: Array[Visitor]
@export var on_exit: Array[Visitor]
