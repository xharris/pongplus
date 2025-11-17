extends Level
class_name Title

func _ready() -> void:
    super._ready()
    _log.debug("start")
    Camera.focal_point_enabled = false
    PlayerPlatform.connect_vertically()
