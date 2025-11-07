extends Node2D
class_name PlatformGroup

static func get_group(platform: Platform) -> PlatformGroup:
    for g: PlatformGroup in platform.get_tree().get_nodes_in_group(Groups.PLATFORM_GROUP):
        if g.platforms.has(platform):
            return g
    return null

@export var position_strategy: PositionStrategy
var platforms: Array[Platform]
var center: Vector2:
    get:
        if platforms.size() == 0:
            return Vector2.ZERO
        var out: Vector2
        for p in platforms:
            out += p.global_position
        return out / platforms.size()

func _ready() -> void:
    add_to_group(Groups.PLATFORM_GROUP)
    update_platforms()

func update_platforms():
    platforms.clear()
    for c in find_children('*'):
        if c is Platform:
            platforms.append(c)
    platforms.sort_custom(func(a: Platform, b: Platform):
        return a.global_position.y < b.global_position.y)
    # connect platforms
    for i in platforms.size() - 1:
        var top: Platform = platforms[i]
        var bottom: Platform = platforms[i+1]
        if bottom:
            top.down = bottom
            bottom.up = top
        # set platform position
        if position_strategy:
            top.position = position_strategy.get_position(i)
            if bottom:
                bottom.position = position_strategy.get_position(i+1)
