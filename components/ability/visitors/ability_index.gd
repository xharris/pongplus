extends AbilityControllerVisitor
class_name AbilityIndex

enum Operation {ADD, SUB, SET}

@export var operation: Operation
@export var value: int

func visit_ability_controller(me: AbilityController):
    match operation:
        Operation.ADD:
            me.queue_index += value
        Operation.SUB:
            me.queue_index -= value
        Operation.SET:
            me.queue_index = value
    me.queue_index = wrapi(value, 0, me.abilities.size())
