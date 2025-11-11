extends FilterStrategy
class_name PlatformFilterStrategy

@export var enabled: bool = true

func filter(item) -> bool:
    if item is Platform:
        if enabled != not item.is_disabled():
            return false
        return true
    return false
