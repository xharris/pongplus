extends Resource
class_name Command

## Does not take array of commands since command properties should 
## be modified before handling.
static func handle(node: Node, command: Command):
    if node.has_method("handle"):
        node.call("handle", command)
