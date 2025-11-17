extends GameVisitor
class_name GameSetLevel

var _log = Logger.new("game_set_level")
@export var level: PackedScene

func visit_game(me: Game):
    var new_level: Level = level.instantiate()
    if not new_level:
        _log.warn("could not instantiate level: %s" % [level.resource_path])
        return
    # destroy previous level
    if me.level:
        Util.destroy_free(me.level)
    # start next level
    me.add_child(new_level)
    me.level = new_level
    me.update()
