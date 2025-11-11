extends Node2D
class_name NodeGroup

static func get_group(node: Node2D) -> NodeGroup:
    if not node:
        return
    for g: NodeGroup in node.get_tree().get_nodes_in_group(Groups.NODE_GROUP):
        if g.is_ancestor_of(node):
            return g
    return

@export var position_strategy: PositionStrategy

var items: Array[Node2D]
var center: Vector2:
    get:
        if items.size() == 0:
            return Vector2.ZERO
        var out: Vector2
        for p in items:
            out += p.global_position
        return out / items.size()

func _ready() -> void:
    add_to_group(Groups.NODE_GROUP)
    update_items()

func update_items():
    items.clear()
    for c in get_children():
        items.append(c)
    items.sort_custom(func(a: NodeGroup, b: NodeGroup):
        return a.global_position.y < b.global_position.y)
    # connect groups
    for i in items.size():
        if position_strategy:
            items[i].global_position = position_strategy.get_position(i)

func find(node: Node) -> int:
    for i in items.size():
        if items[i].is_ancestor_of(node):
            return i
    return -1
