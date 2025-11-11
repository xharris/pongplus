## Position list of nodes in specific formation (formations in ./strategies)
extends Resource
class_name PositionStrategy

var nodes: Array[Node2D]

static func to_2d(i: int, columns: int) -> Vector2i:
    return Vector2i(i / columns, i % columns)

static func to_1d(xy: Vector2i, columns: int) -> int:
    return (xy.y * columns) + xy.x

static func get_current_scene() -> Node:
    return Engine.get_main_loop().current_scene

## Override
func get_position(index: int) -> Vector2:
    return Vector2.ZERO

## Override (optional)
func get_neighbor(i: int, direction: Vector2i) -> int:
    return -1
