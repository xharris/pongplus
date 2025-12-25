extends Level
class_name Title

@onready var player_spawn: Marker2D
    
func _on_player_created(player: Player):
    super._on_player_created(player)
    player.team = 0
