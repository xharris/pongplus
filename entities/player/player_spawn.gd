extends Node2D
class_name PlayerSpawn

var _log = Logger.new("player_spawn")
@export var player_controller_configs: Array[PlayerControllerConfig]

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("attack") or event.is_action_pressed("jump"):
        for c in player_controller_configs:
            for p: Player in get_tree().get_nodes_in_group(Groups.PLAYER):
                if p.player_controller_config.device == event.device:
                    # player already spawned
                    return
            if c.device == event.device:
                # player wants to join
                var player: Player = Player.SCENE.instantiate()
                player.player_controller_config = c
                _log.info("player %d join (%v)" % [c.device, player.global_position])
                add_child(player)
                player.global_position = global_position
