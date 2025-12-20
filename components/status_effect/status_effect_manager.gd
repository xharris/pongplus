extends Node2D
class_name StatusEffectManager

signal status_effect_added(e: StatusEffect)

var effects: Array[StatusEffect]

func accept(v: Visitor):
    if v is StatuEffectManagerVisitor:
        v.visit_status_effect_manager(self)

func apply(node: Node = null):
    if not node:
        node = get_parent()
    if not node:
        return
    for e in effects:
        e.apply(node)

func handle(command: Command) -> Command:
    for e in effects:
        command = e.handle(command)
    return command
