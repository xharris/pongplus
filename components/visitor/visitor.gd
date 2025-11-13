extends Resource
class_name Visitor

static func visit(node: Node, visitors: Array[Visitor]):
    if node.has_method("accept"):
        for v in visitors:
            node.call("accept", v)
    var root = Engine.get_main_loop().current_scene
    for v in visitors:
        if v is SceneVisitor:
           v.visit_current_scene(root)
