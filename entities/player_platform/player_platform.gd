extends Node2D
class_name PlayerPlatform

static func connect_vertically():
    var root = Engine.get_main_loop().current_scene
    if not root:
        return
    # connect platforms
    for g: NodeGroup in root.get_tree().get_nodes_in_group(Groups.NODE_GROUP):
        # get platforms in group
        var platforms: Array[Platform]
        for p: Platform in root.get_tree().get_nodes_in_group(Groups.PLATFORM):
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


@onready var platform: Platform = $Platform
@onready var hitbox: Hitbox = $Hitbox

func accept(v: Visitor):
    if v is PlatformVisitor:
        platform.accept(v)
    elif v is HitboxVisitor:
        hitbox.accept(v)
    
func _ready() -> void:
    hitbox.accepted_visitor.connect(accept)
    update()
    
func update():
    platform._log.set_prefix(name)
    hitbox._log.set_prefix(name)
