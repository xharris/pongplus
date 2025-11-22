extends Level
class_name Title

func _ready() -> void:
    super._ready()
    _log.debug("start")
    PlayerPlatform.connect_vertically()
