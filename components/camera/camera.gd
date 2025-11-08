extends Node2D
class_name Camera

static func update_view(delta: float):
    var root = Engine.get_main_loop().root
    var canvas_transform = Transform2D.IDENTITY
    for c: Camera in root.get_tree().get_nodes_in_group(Groups.CAMERA):
        canvas_transform *= c._xform
    root.get_viewport().canvas_transform = canvas_transform

@export var shake_duration: float = 1.5
@export var shake_intensity: float = 30

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
