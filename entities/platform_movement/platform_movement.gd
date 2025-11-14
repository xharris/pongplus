extends Node2D
class_name PlatformMovement

signal moved(p: Platform)

var _log = Logger.new("platform_movement")#, Logger.Level.DEBUG)
var _current: Platform

func _ready() -> void:
    move_to_closest.call_deferred()

func get_current_platform() -> Platform:
    return _current

func move_up() -> bool:
    if not _current:
        _log.warn("not currently on a platform")
        return false
    var next = _current.up
    if not next:
        return false
    while next and not can_move_to(next):
        next = next.up
    return move_to_platform(next)

func move_down() -> bool:
    if not _current:
        _log.warn("not currently on a platform")
        return false
    var next = _current.down
    if not next:
        return false
    while next and not can_move_to(next):
        next = next.down
    return move_to_platform(next)

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
    return other and not other.is_disabled()

func move_to_platform(next: Platform) -> bool:
    if not next:
        _log.debug("given 'next' platform is null")
        return false
    if not can_move_to(next):
        _log.debug("illegal platform move")
        return false
    _current = next
    moved.emit(_current)
    return true
