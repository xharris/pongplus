extends StatusEffectManagerVisitor
class_name RemoveStatusEffect

@export var id: StringName
## Remove all or just the first one found
@export var all: bool = true

func visit_status_effect_manager(me: StatusEffectManager):
    for i in range(me.effects.size() - 1, -1, -1):
        var e = me.effects[i]
        if e.id == id:
            me.effects.remove_at(i)
