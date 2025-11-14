extends Resource
class_name Visitor

static func visit(node: Node, visitors: Array[Visitor]):
    if node.has_method("accept"):
        for v in visitors:
            await node.call("accept", v)
