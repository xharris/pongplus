extends Node2D
class_name Platform

static var _static_log = Logger.new("platform")

@onready var sprite: Sprite2D = %Sprite2D

var _log = Logger.new("platform")
@export var up: Platform
@export var down: Platform
var _disabled: bool = true
var _img_enabled = preload("res://components/platform/circle.png")
var _img_disabled = preload("res://components/platform/x.png")

func accept(v: Visitor):
    if v is PlatformVisitor:
        v.visit_platform(self)

func _ready() -> void:
    add_to_group(Groups.PLATFORM)
    enable()

func disable():
    sprite.texture = _img_disabled
    sprite.modulate = MUI.RED_500
    if _disabled:
        return
    _disabled = true

func enable():
    sprite.texture = _img_enabled
    sprite.modulate = MUI.GREEN_500
    if not _disabled:
        return
    _disabled = false

func is_disabled() -> bool:
    return _disabled
