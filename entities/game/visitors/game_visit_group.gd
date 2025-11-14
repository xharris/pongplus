extends GameVisitor
class_name GameVisitGroup

@export var group: StringName
@export var visitors: Array[Visitor]

func visit_game(me: Game):
    for n in me.get_tree().get_nodes_in_group(group):
        Visitor.visit(n, visitors)
