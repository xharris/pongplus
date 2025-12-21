extends StatusEffectManagerVisitor
class_name AddStatusEffect

@export var effect: StatusEffect

func visit_status_effect_manager(me: StatusEffectManager):
    me.add_effect(effect)
