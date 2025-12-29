extends Level
class_name Title

const WAND = preload("res://entities/weapons/wand/wand.tscn")

@onready var training_dummy: TrainingDummy = %TrainingDummy
@onready var title: Label = %Title
@onready var how_to_play: Label = %HowToPlay
    
func _ready() -> void:
    super._ready()
    Groups.TEAM(training_dummy, 1)

func _on_player_created(player: Player):
    super._on_player_created(player)
    # add to team
    Groups.TEAM(player, 0)
    # give them a weapon
    player.character.set_weapon(WAND.instantiate())
