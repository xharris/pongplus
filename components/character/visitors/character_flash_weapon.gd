extends CharacterVisitor
class_name CharacterFlashWeapon

@export var duration: float
@export var color: Color = Color.WHITE
@export var contrast: float = 1.0

func visit_character(me: Character):
    me.set_weapon_color(color, contrast)
    var _flash_timer = Timer.new()
    _flash_timer.wait_time = duration
    _flash_timer.autostart = true
    _flash_timer.timeout.connect(me.set_weapon_color)
    me.add_child(_flash_timer)
