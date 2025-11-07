extends Node2D
class_name Platform

static var _static_log = Logger.new("platform")

var _log = Logger.new("platform")
@export var up: Platform
@export var down: Platform

func _ready() -> void:
    add_to_group(Groups.PLATFORM)
