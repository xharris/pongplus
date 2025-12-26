extends Level
class_name Title

@onready var training_dummy: Node2D = %TrainingDummy
    
func _ready() -> void:
    super._ready()
    Groups.TEAM(training_dummy, 1)
    
func _on_player_created(player: Player):
    super._on_player_created(player)
    Groups.TEAM(player, 0)
