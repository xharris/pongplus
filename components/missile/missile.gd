extends CharacterBody2D
class_name Missile
## TODO use manual velocity instead of tween

enum CurveSide {TOP, MID, BOT}

signal started_path_to(target: Node2D)

## Seconds
const MISSILE_DURATION_MIN: float = 3
## Seconds
const MISSILE_DURATION_MAX: float = 1
const DRAW_DEBUG: bool = false

@export var speed_curve: Curve = preload("res://components/missile/missile_curve.tres")

var _log = Logger.new("missile", Logger.Level.DEBUG)
var _current_curve: Curve2D
var tween: Tween
var target_history: Array[Node2D]
var curve_distance: float = 50
var missile_position: Vector2
var is_pathing: bool:
    get:
        return curve != null

## [0, 1]
var duration_curve_position: float:
    set(v):
        duration_curve_position = clampf(v, 0, 1)
var duration_curve: Curve = preload("res://components/missile/default_duration_curve.tres")
var delta_rate: float = 1.0
var curve: Curve2D
var curve_side: CurveSide = CurveSide.MID
var curve_angle_offset: float = 50

var _curve_progress: float = 0
var _debug_midpoint: Vector2
var _debug_control_point: Vector2
var _curve_dir_sign: int = 1
var _last_position: Vector2

func accept(v: Visitor):
    if v is MissileVisitor:
        v.visit_missile(self)

func _process(delta: float) -> void:
    if curve:
        _curve_progress += delta * delta_rate * duration_curve.sample(duration_curve_position)
        # get position from curve
        _last_position = global_position
        var next_position = curve.sample(0, _curve_progress)
        velocity = next_position - _last_position
    if _curve_progress >= 1:
        stop_pathing()
    move_and_slide()
    
func _draw() -> void:
    if DRAW_DEBUG:
        draw_circle(_debug_midpoint, 10, Color.RED)
        draw_circle(_debug_control_point, 10, Color.GREEN)
        if curve:
            draw_polyline(curve.get_baked_points(), Color.BLUE, 2)

func _ready() -> void:
    add_to_group(Groups.MISSILE)
          
func path_to(target: Node2D, speed: float = 10):
    if not target:
        _log.warn("path to null target (%s)" % [self])
        return
    stop_pathing()
    target_history.append(target)
    var target_position = target.global_position
    var midpoint = (target_position + global_position) / 2
    _debug_midpoint = midpoint
    # calculate control point
    var direction_to = global_position.direction_to(target_position)
    var angle_to = global_position.angle_to_point(target_position)
    var dir_sign = (1 if global_position < target_position else -1)
    var new_curve_distance = curve_distance
    match curve_side:
        CurveSide.TOP:
            dir_sign = (1 if global_position < target_position else -1)
        CurveSide.BOT:
            dir_sign = (1 if global_position < target_position else -1) * -1
        CurveSide.MID:
            new_curve_distance /= 2
    var control_angle = angle_to - \
        deg_to_rad(dir_sign * (90 + curve_angle_offset))
    var control_point = midpoint + \
        (Vector2.from_angle(control_angle) * new_curve_distance)
    # create curve
    curve = Curve2D.new()
    curve.add_point(global_position)
    curve.add_point(target_position)
    # create curve between ball and target
    curve.set_point_out(0, control_point - global_position)
    curve.set_point_in(1, control_point - target_position)
    started_path_to.emit(target)

func stop_pathing():
    _curve_progress = 0
    curve = null
