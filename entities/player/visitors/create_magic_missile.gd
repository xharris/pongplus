extends PlayerVisitor
class_name CreateMagicMissile

const SCENE = preload("res://entities/magic_missile/magic_missile.tscn")

var _log = Logger.new("create_magic_missile")#, Logger.Level.DEBUG)
@export var config: MagicMissileConfig

func visit_player(me: Player):
    _log.debug("create magic missile: %s" % [config.resource_path.get_file()])
    var new = SCENE.instantiate()
    new.config = config
    new.global_position = me.global_position
    me.add_child(new)
