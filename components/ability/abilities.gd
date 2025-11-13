extends Resource
class_name Abilities

@export var abilities: Array[Ability]

var _node: Node

func use(node: Node):
    _node = node
    if not node:
        return
    for a in abilities:
        Visitor.visit(_node, a.on_ready)

func add(a: Ability):
    abilities.append(a)
    if _node:
        Visitor.visit(_node, a.on_ready)

func has(a: Ability) -> bool:
    for a2 in abilities:
        if a.name == a2.name:
            return true
    return false
