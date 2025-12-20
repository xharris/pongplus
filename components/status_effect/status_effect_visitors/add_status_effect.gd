extends StatuEffectManagerVisitor
class_name AddStatusEffect

@export var effect: StatusEffect
## -1 = infinite (until removed)
@export var duration: float = -1

func visit_status_effect_manager(me: StatusEffectManager):
    me.effects.append(effect)
