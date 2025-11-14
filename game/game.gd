extends Node2D
class_name Game

const ABILITY_BALL: Ability = preload("res://resources/abilities/ball.tres")

@export var gameplay: Gameplay

func accept(v: Visitor):
    if not is_inside_tree():
        return
    if v is GameVisitor:
        v.visit_game(self)

func _ready() -> void:
    add_to_group(Groups.GAME)
    EventBus.ball_created.connect(_on_ball_created, CONNECT_DEFERRED)
    EventBus.ball_destroyed.connect(_on_ball_destroyed)
    EventBus.player_health_current_changed.connect(_on_player_health_current_changed)
    Visitor.visit(self, gameplay.on_start)
    
func _process(delta: float) -> void:
    Camera.update_view(delta)
    
func _on_player_health_current_changed(player: Player, amount: int):
    if amount < 0 and player.health.is_alive():
        Visitor.visit(self, gameplay.on_player_take_damage)
        Visitor.visit(player, gameplay.on_player_take_damage)
    
func _on_ball_created(ball: Ball):
    if not Ability.has_ability(ball.abilities, ABILITY_BALL):
        ball.abilities.append(ABILITY_BALL)

func _on_ball_destroyed(ball: Ball):
    Visitor.visit(self, gameplay.on_ball_destroyed)
    Visitor.visit(ball, gameplay.on_ball_destroyed)
