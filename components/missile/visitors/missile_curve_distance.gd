extends MissileVisitor
class_name MissileCurveDistance

enum Operation {Add}

@export var operation: Operation
@export var value: float
@export var min: float = 50
@export var max: float = 70

func visit_missile(me: Missile):
    match operation:
        Operation.Add:
            me.curve_distance += value
