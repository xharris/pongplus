extends Resource
class_name Ability

@export var name: String
@export var on_ready: Array[Visitor]

@export var on_me_hit_missile_straight: Array[Visitor]
@export var on_me_hit_missile_up: Array[Visitor]
@export var on_me_hit_missile_down: Array[Visitor]

@export var on_me_hit_ball: Array[Visitor]
@export var on_ball_hit_me: Array[Visitor]

@export var on_me_hit_player_platform: Array[Visitor]
