extends Resource
class_name Visitor

const ACCEPTED_VISITOR = &"accepted_visitor"
static var _static_log = Logger.new("visitor")

static func visit(me: Node, visitors: Array[Visitor]):
    for v in visitors:
        if me.has_method("accept"):
            await me.call("accept", v)
            await v.visit_any(me)
        # trigger accepted signal if available
        #if me.has_signal(ACCEPTED_VISITOR):
            #me.emit_signal(ACCEPTED_VISITOR, v)
            
func visit_any(_node: Node):
    pass
