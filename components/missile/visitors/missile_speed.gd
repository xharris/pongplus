extends MissileVisitor
class_name MissileSpeed

enum Type {ADD, SUB, SET}

@export var type: Type
@export var amount: float = 0.05

func visit_missile(me: Missile):
    match type:
        Type.ADD:
            me.speed += amount
        Type.SUB:
            me.speed -= amount
        Type.SET:
            me.speed = amount
