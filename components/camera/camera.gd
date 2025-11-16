extends Node2D
class_name Camera

static var _static_log = Logger.new("camera")#, Logger.Level.DEBUG)

static var focal_speed: float = 2.0
static var total_transform: Transform2D
static var focal_point_enabled: bool = true

static func update_view(_delta: float):
    var root: Node2D = Engine.get_main_loop().current_scene
    if not root:
        return
    var canvas_xform = Transform2D.IDENTITY
    var view_center = root.get_viewport().get_visible_rect().size / 2
    # calculate focal point
    var focal_xform = Transform2D.IDENTITY
    if focal_point_enabled:
        var focal_point_offset: Vector2
        for c: Camera in root.get_tree().get_nodes_in_group(Groups.CAMERA):
            if not c.is_visible_in_tree():
                continue
            # apply camera's calculated transform
            canvas_xform *= c._xform
            # use camera as a focal point
            if c.is_focal_point:
                focal_point_offset -= lerp(Vector2.ZERO, c.global_position - view_center, c.focal_point_weight)
        
        focal_xform = focal_xform.translated(focal_point_offset)
    total_transform = total_transform.interpolate_with(focal_xform, _delta * focal_speed) * canvas_xform
    root.get_viewport().canvas_transform = total_transform

@export var offset: float = 0
@export var shake_duration: float = 1.5
@export var shake_intensity: float = 30
@export var is_focal_point: bool = false
## Midpoint to follow between center of screen and focal point.[br]
## [code]0.0[/code] is center of view (no camera offset)[br]
## [code]0.5[/code] is halfway between both[br]
## [code]1.0[/code] is camera node location[br]
@export var focal_point_weight: float = 0.2

var _log = Logger.new("camera")
var _shake_t: float = 0
var _shake_offset: Vector2 = Vector2(0, 0)
var t: float = 0
var _xform: Transform2D

func accept(v: Visitor):
    if v is CameraVisitor:
        v.visit_camera(self)

func _ready() -> void:
    add_to_group(Groups.CAMERA)

func _process(delta: float) -> void:
    _xform = Transform2D.IDENTITY
    # shake camera
    if _shake_t > 0 and shake_duration > 0:
        _xform = _xform.translated(sin(t) * _shake_offset)
        var amount = (shake_duration - _shake_t) / shake_duration
        _shake_offset = _shake_offset.lerp(Vector2.ZERO, amount)
        _shake_t -= delta
        t += delta * shake_intensity

func shake(amount: Vector2, duration: float = shake_duration):
    _shake_offset = amount
    _shake_t = duration
