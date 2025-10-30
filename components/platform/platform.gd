extends Node2D
class_name Platform

class Group:
    var index: int
    ## ordered from top to bottom
    var platforms: Array[Platform]

static var _static_log = Logger.new("platform")
static var groups: Array[Group]

static func refresh_group_indexes():
    var platforms: Array[Platform]
    platforms.assign(
        Engine.get_main_loop().root.get_tree().get_nodes_in_group(Groups.PLATFORM)
    )
    for p in platforms:
        p.group_index = 0
    var index = 1
    for p in platforms:
        if not p._spread_group_index(index):
            index += 1
    # create platform groups
    groups.clear()
    for i in index - 1:
        var group = Group.new()
        groups.append(group)
        group.index = i + 1
        # add paltforms in this group
        for p in platforms:
            if p.group_index == group.index:
                group.platforms.append(p)
        # sort from top to bottom
        group.platforms.sort_custom(func(a: Platform, b: Platform):
            return a.global_position.y <= b.global_position.y)
    _static_log.debug("refreshed group indexes, groups=%d" % [groups.size()])

var _log = Logger.new("platform")
@export var up: Platform
@export var down: Platform
var group_index: int

func _ready() -> void:
    add_to_group(Groups.PLATFORM)
    refresh_group_indexes()

func _spread_group_index(index: int) -> bool:
    if group_index == index:
        return false
    group_index = index
    if up:
        up._spread_group_index(index)
    if down:
        down._spread_group_index(index)
    return true

func index_in_group() -> int:
    for g in groups:
        if g.index == group_index:
            return g.platforms.find(self)
    return -1
