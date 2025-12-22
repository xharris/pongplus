extends PlayerVisitor
class_name PlayerOutOfBounds

@export var bounds: Player.Bounds

func visit_player(me: Player):
    me.set_bounds(bounds)
