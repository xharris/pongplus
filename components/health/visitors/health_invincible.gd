extends HealthVisitor
class_name HealthInvincible

@export var invincible: bool = false

func visit_health(me: Health):
    me.invincible = invincible
