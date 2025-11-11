extends PositionStrategy
class_name GridPositionStrategy

var _log = Logger.new("grid_position_strategy")#, Logger.Level.DEBUG)
## rows/columns
@export var size: Vector2i = Vector2i.ONE
## row/column offset
@export var offset: Vector2i = Vector2i.ZERO

func get_position(i: int) -> Vector2:
    var pos: Vector2i = to_2d(i, size.x)
    pos += offset
    var view_size = get_current_scene().get_viewport().get_visible_rect().size
    var cell_size = view_size / Vector2(size)
    var out = Vector2(pos) * cell_size
    _log.debug("i=%d pos=%v out=%v" % [i, pos, out])
    return out
