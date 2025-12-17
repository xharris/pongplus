extends Node2D
class_name Game

@onready var level: Level = $Title
@onready var score: ScoreOverlay = %ScoreOverlay

var _log = Logger.new("game")
@export var log_level: Logger.Level = Logger.Level.DEBUG

func accept(v: Visitor):
    if not is_inside_tree():
        _log.warn("Cannot visit %s. Game not in tree yet." % [v.resource_path])
        return
    if v is GameVisitor:
        v.visit_game(self)
    if v is ScoreOverlayVisitor:
        v.visit_score_overlay(score)

func _init() -> void:
    update()

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
