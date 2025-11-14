extends Node2D
class_name Missile

signal started_path_to(target: Node2D)

## Seconds
const MISSILE_DURATION_MIN: float = 3
## Seconds
const MISSILE_DURATION_MAX: float = 1
const DRAW_DEBUG: bool = false

var _log = Logger.new("missile")
var _current_curve: Curve2D
var _tween: Tween

var duration_curve: Curve = preload("res://components/missile/default_duration_curve.tres")
var target_history: Array[Node2D]
var curve_distance: float = 50
var missile_position: Vector2
## [0, 1]
var duration_curve_position: float:
    set(v):
        duration_curve_position = clampf(v, 0, 1)
var is_pathing: bool:
    get:
        return _tween and _tween.is_running()
var _last_position: Vector2
var velocity: Vector2
var _debug_midpoint: Vector2
var _debug_control_point: Vector2
var curve: Curve2D

func accept(v: Visitor):
    if v is MissileVisitor:
        v.visit_missile(self)

func _process(delta: float) -> void:
    velocity = (global_position - _last_position).normalized()
    _last_position = global_position
    
func _draw() -> void:
    if DRAW_DEBUG:
        draw_circle(_debug_midpoint, 10, Color.RED)
        draw_circle(_debug_control_point, 10, Color.GREEN)
        if curve:
            draw_polyline(curve.get_baked_points(), Color.BLUE, 2)

func _ready() -> void:
    add_to_group(Groups.MISSILE)
          
func path_to(target: Node2D):
    if not target:
        _log.warn("path to null target (%s)" % [self])
        return
    target_history.append(target)
    var target_position = target.global_position
    var midpoint = (target_position + global_position) / 2
    _debug_midpoint = midpoint
    # get tangent to direction
    var direction_to = global_position.direction_to(target_position)
    var angle_to = global_position.angle_to_point(target_position)
    var control_angle = angle_to - \
        deg_to_rad(90)
    ## TODO add parameter control_point_target to get angle instead of hardcoded 90?
    var control_point = midpoint + \
        (Vector2.from_angle(control_angle) * curve_distance)
    # create curve
    curve = Curve2D.new()
    curve.add_point(global_position)
    curve.add_point(target_position)
    # create curve between ball and target
    curve.set_point_out(0, control_point - global_position)
    curve.set_point_in(1, control_point - target_position)
    _tween = create_tween()
    _tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
    _tween.set_trans(Tween.TRANS_LINEAR)
    _tween.tween_method(
        func(p):
            missile_position = curve.sample(0, p),
        0.0, 1.0,
        lerp(
            MISSILE_DURATION_MIN,
            MISSILE_DURATION_MAX,
            duration_curve.sample(duration_curve_position),
        )
    )
    _log.debug("target %s" % [target])
    started_path_to.emit(target)

func stop_pathing():
    if _tween:
        _tween.stop()
        _tween = null
