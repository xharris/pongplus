extends Node
class_name Util

static func get_ancestor(node: Node, ancestor_cls) -> Node:
    if not node or node is Window:
        return
    if is_instance_of(node, ancestor_cls):
        return node
    return get_ancestor(node.get_parent(), ancestor_cls)
