extends Visitor
class_name AnyWait

@export var seconds: float

func visit_any(me: Node):
    await me.get_tree().create_timer(seconds).timeout
