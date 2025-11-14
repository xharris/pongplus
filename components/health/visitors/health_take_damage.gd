extends HealthVisitor
class_name HealthTakeDamage

@export var amount: int

func visit_health(me: Health):
    me.take_damage(amount)
