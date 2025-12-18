extends PlayerVisitor
class_name CreateMagicMissile

const SCENE = preload("res://entities/magic_missile/magic_missile.tscn")

var _log = Logger.new("create_magic_missile")
@export var config: MagicMissileConfig

func visit_player(me: Player):
    var new = SCENE.instantiate()
    new.config = config
    new.global_position = me.global_position
    me.add_child(new)
