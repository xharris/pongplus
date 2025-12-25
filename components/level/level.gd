extends Node2D
class_name Level

signal accepted_visitor(v: Visitor)

var _log = Logger.new("level", Logger.Level.DEBUG)
@export var gameplay: Gameplay
## Used for logging id
@export var id: String

func accept(v: Visitor):
    accepted_visitor.emit(v)

func _ready() -> void:
    if not id.is_empty():
        _log.set_id(id)
    EventBus.player_created.connect(_on_player_created)
    EventBus.player_health_current_changed.connect(_on_player_health_current_changed)
    
    _log.debug("start")
    update()
    if not _log.warn_if(not gameplay, "gameplay not set"):
        Visitor.visit.call_deferred(self, gameplay.on_start)

func _on_player_created(player: Player):
    update()

func _on_player_health_current_changed(player: Player, amount: int):
    if gameplay and amount < 0 and player.health.is_alive():
        Visitor.visit(self, gameplay.on_player_take_damage)
        Visitor.visit(player, gameplay.on_player_take_damage)

func update():
    # set player abilities
    if gameplay and not gameplay.player_abilties.is_empty():
        for p in get_tree().get_nodes_in_group(Groups.PLAYER):
            _log.debug("add player ability: %s" % [p.abilities.map(func(a:Ability): return a.name)])
            p.abilities = gameplay.player_abilties.duplicate(true)

    # set ball abilities
    if gameplay and not gameplay.player_abilties.is_empty():
        for b in get_tree().get_nodes_in_group(Groups.BALL):
            _log.debug("add ball ability: %s" % [b.abilities.map(func(a:Ability): return a.name)])
            b.abilities = gameplay.ball_abilities.duplicate(true)
