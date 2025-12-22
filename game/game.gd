extends Node2D
class_name Game

@onready var level: Level = $Title
@onready var score: ScoreOverlay = %ScoreOverlay

var _log = Logger.new("game")
@export var log_level: Logger.Level = Logger.Level.DEBUG

var visitor_source: Node

func accept(v: Visitor):
    if not is_inside_tree():
        _log.warn("Cannot visit %s. Game not in tree yet." % [v.resource_path])
        return
    if v is GameVisitor:
        v.visit_game(self)
    if v is ScoreOverlayVisitor:
        v.visit_score_overlay(score)

func accept_with_source(v: Visitor, source: Node):
    visitor_source = source
    accept(v)
    visitor_source = null

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
        level.accepted_visitor.connect(accept_with_source.bind(level))
    if is_inside_tree():
        for p: Player in get_tree().get_nodes_in_group(Groups.PLAYER):
            Util.connect_once(
                p.accepted_visitor,
                accept_with_source.bind(p))
            Util.connect_once(
                p.bounds_changed,
                _on_player_bounds_changed.bind(p))

func _on_player_bounds_changed(bounds: Player.Bounds, me: Player):
    _log.info("%s bounds changed: %s" % [me.name, Player.Bounds.find_key(bounds)])
