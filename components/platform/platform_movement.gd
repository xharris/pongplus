extends Node2D
class_name PlatformMovement

signal moved(p: Platform)

var _log = Logger.new("platform_movement")
var _current: Platform

func _ready() -> void:
    move_to_closest.call_deferred()

func move_up() -> bool:
    if not _current:
        _log.warn("not currently on a platform")
        return false
    return move_to_platform(_current.up)

func move_down() -> bool:
    if not _current:
        _log.warn("not currently on a platform")
        return false
    return move_to_platform(_current.down)

func move_to_closest():
    # get nearest platform
    var closest: Platform
    for p: Platform in get_tree().get_nodes_in_group(Groups.PLATFORM):
        if not closest or _distance_to_platform(p) < _distance_to_platform(closest):
            closest = p
    # move to closest
    if closest:
        move_to_platform(closest)
    else:
        _log.warn("could not find closest platform")
        
func _distance_to_platform(p: Platform) -> float:
    return global_position.distance_to(p.global_position)
    
func can_move_to(other: Platform):
    return not _current or (_current.up == other or _current.down == other)

func move_to_platform(next: Platform) -> bool:
    if not next:
        return false
    if not can_move_to(next):
        return false
    _current = next
    moved.emit(_current)
    return true
