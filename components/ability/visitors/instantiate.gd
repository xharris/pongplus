extends AbilityControllerVisitor
class_name AbilityInstantiate

var _log = Logger.new("ability_instantiate")
@export var scene: PackedScene
@export var visitors: Array[Visitor]

func visit_ability_controller(me: AbilityController):
    var node = scene.instantiate() as Node2D
    if not node:
        _log.warn("scene is not a Node2D: %s" % [scene.resource_path])
        return
    me.add_child(node)
    node.global_position = me.global_position
    Visitor.visit(node, visitors)
    me.instantiated.emit(node)
