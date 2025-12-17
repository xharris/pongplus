@tool
extends Control

@onready var tab_container: TabContainer = %TabContainer
@onready var tree: Tree = %Tree

var icon = preload("res://entities/ball/ball.png")

func _ready() -> void:
    tab_container.set_tab_icon(1, icon)
    
    var root = tree.create_item()
    root.set_text(0, "root")
    var child1 = _add_tree_child(root, "child 1, child 1, child 1")
    _add_tree_child(child1, "child 2, child 2, child 2")
    _add_tree_child(root, "child 3, child 3, child 3")

func _add_tree_child(root: TreeItem, label: String = "") -> TreeItem:
    var child = root.create_child()
    child.set_text(0, label)
    child.set_icon(0, icon)
    return child
