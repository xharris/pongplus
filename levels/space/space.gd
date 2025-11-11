extends Node2D

func _ready() -> void:
    # connect platforms
    for g: NodeGroup in get_tree().get_nodes_in_group(Groups.NODE_GROUP):
        # get platforms in group
        var platforms: Array[Platform]
        for p: Platform in get_tree().get_nodes_in_group(Groups.PLATFORM):
            if g.is_ancestor_of(p):
                platforms.append(p)
        # order platforms top to bottom
        platforms.sort_custom(func(a: Platform, b: Platform):
            return a.global_position.y < b.global_position.y)
        for i in platforms.size() - 1:
            var top = platforms[i]
            var bottom = platforms[i+1]
            if bottom:
                top.down = bottom
                bottom.up = top
