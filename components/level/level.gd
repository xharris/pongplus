extends Node2D
class_name Level
## DONT FORGET to call super method when overriding

signal accepted_visitor(v: Visitor)

var _log = Logger.new("level", Logger.Level.DEBUG)
@export var gameplay: Gameplay
## Used for logging id
@export var id: String

func accept(v: Visitor):
    accepted_visitor.emit(v)

func _init() -> void:
    EventBus.player_created.connect(_on_player_created, CONNECT_DEFERRED)
    EventBus.player_health_current_changed.connect(_on_player_health_current_changed, CONNECT_DEFERRED)
    
func _ready() -> void:
    if not id.is_empty():
        _log.set_id(id)
    _log.debug("start")
    if not _log.warn_if(not gameplay, "gameplay not set"):
        Visitor.visit.call_deferred(self, gameplay.on_start)

func _on_player_created(player):
    Visitor.visit(player, gameplay.on_player_spawn)

func _on_player_health_current_changed(player: Player, amount: int):
    if gameplay and amount < 0 and player.health.is_alive():
        Visitor.visit(self, gameplay.on_player_take_damage)
        Visitor.visit(player, gameplay.on_player_take_damage)
