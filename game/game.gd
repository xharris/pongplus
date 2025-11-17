extends Node2D
class_name Game

const ABILITY_BALL: Ability = preload("res://resources/abilities/ball.tres")
const LEVEL_SPACE = preload("res://levels/space/space.tscn")

@onready var level: Level = $Title
@onready var score: ScoreOverlay = %ScoreOverlay

var _log = Logger.new("game")
@export var log_level: Logger.Level = Logger.Level.INFO

func accept(v: Visitor):
    if not is_inside_tree():
        return
    if v is GameVisitor:
        v.visit_game(self)
    if v is ScoreOverlayVisitor:
        v.visit_score_overlay(score)

func _ready() -> void:
    add_to_group(Groups.GAME)
    update()
    _log.debug("start")
    
func _process(delta: float) -> void:
    Camera.update_view(delta)
    
func update():
    Logger.global_level = log_level
    if level and not level.accepted_visitor.is_connected(accept):
        level.accepted_visitor.connect(accept)
