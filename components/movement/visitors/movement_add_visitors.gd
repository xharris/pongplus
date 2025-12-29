extends MovementVisitor
class_name MovementAddVisitors

@export var visitors: Array[Visitor]

func visit_movement(me: Movement):
    me.visitors.append_array(visitors)
