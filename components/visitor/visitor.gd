extends Resource
class_name Visitor

static func visit(me: Node, visitors: Array[Visitor]):
    if me.has_method("accept"):
        for v in visitors:
            await me.call("accept", v)
            await v.visit_any(me)
            
func visit_any(_node: Node):
    pass
