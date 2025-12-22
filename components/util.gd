extends Resource
class_name Util

static func get_ancestor(node: Node, ancestor_cls) -> Node:
    if not node or node is Window:
        return
    if is_instance_of(node, ancestor_cls):
        return node
    return get_ancestor(node.get_parent(), ancestor_cls)

static func find_child(parent: Node, child_cls) -> Node:
    for c: Node in parent.find_children('*'):
        if is_instance_of(c, child_cls):
            return c
    return

static func find_first_child_in_group(parent: Node, group: StringName) -> Node:
    for n: Node in parent.get_tree().get_nodes_in_group(group):
        if parent.is_ancestor_of(n):
            return n
    return
    
static func destroy_free(node: Node):
    #var parent = node.get_parent()
    #if parent:
        #parent.remove_child.call_deferred(node)
    node.queue_free()

## Returns value between [0, 1]
static func diminishing(value, rate_of_change = 0):
    if value + rate_of_change == 0:
        return 0
    return value / (value + rate_of_change)

static func connect_once(sig: Signal, fn: Callable, flags: int = 0):
    if not sig.is_connected(fn):
        sig.connect(fn, flags)
