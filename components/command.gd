extends Resource
class_name Command

static func handle(node: Node, cmd: Command):
    if node.has_method("handle"):
        node.call("handle", cmd)
