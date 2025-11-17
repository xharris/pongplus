extends Level
class_name Space

@onready var left: NodeGroup = %Left
@onready var right: NodeGroup = %Right

## TODO move these to Gameplay resource
@export var on_ready: Array[Visitor]
@export var on_player_left_take_damage: Array[Visitor]
@export var on_player_right_take_damage: Array[Visitor]

#var _log = Logger.new("space")#, Logger.Level.DEBUG)

func accept(v: Visitor):
    accepted_visitor.emit(v)

func _ready() -> void:
    super._ready()
    EventBus.player_health_current_changed.connect(_on_player_health_current_changed)
    
    PlayerPlatform.connect_vertically()
    Visitor.visit.call_deferred(self, on_ready)

func _on_player_health_current_changed(player: Player, amount: int):
    super._on_player_health_current_changed(player, amount)
    _log.debug("player took dmg: %d" % [amount])
    if amount < 0:
        var group = NodeGroup.get_group(player.movement.get_current_platform())
        match group:
            left:
                Visitor.visit(self, on_player_left_take_damage)
                Visitor.visit(player, on_player_left_take_damage)
            right:
                Visitor.visit(self, on_player_right_take_damage)
                Visitor.visit(player, on_player_right_take_damage)
            _:
                _log.warn("could not find platform group, player=%s, current platform=%s" % [player, player.movement.get_current_platform()])
