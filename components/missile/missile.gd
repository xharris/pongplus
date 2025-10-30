extends Node2D
class_name Missile

var _current_curve: Curve2D
var _tween: Tween

var target_history: Array[Node2D]
var curve_distance: float = 0
var missile_position: Vector2

func _process(delta: float) -> void:
    if _current_curve:
        pass

func path_to(target: Node2D):
    target_history.append(target)
    var target_position = target.global_position
    var midpoint = (target_position + global_position) / 2
    # get tangent to direction
    var direction_to = global_position.direction_to(target_position)
    var angle_to = global_position.angle_to_point(target_position)
    var control_angle = angle_to - \
        deg_to_rad(90)
    ## TODO add 180deg if control_point is offscreen?
    var control_point = midpoint + \
        (Vector2.from_angle(control_angle) * curve_distance)
    # create curve
    var curve = Curve2D.new()
    curve.add_point(global_position)
    curve.add_point(target_position)
    # create curve between ball and target
    curve.set_point_out(0, control_point - global_position)
    curve.set_point_in(1, control_point - target_position)
    _tween = create_tween()
    _tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
    _tween.set_trans(Tween.TRANS_LINEAR)
    #_tween.set_ease(Tween.EASE_OUT)
    _tween.tween_method(
        func(p):
            missile_position = curve.sample(0, p),
        0.0, 1.0,
        3
    )
