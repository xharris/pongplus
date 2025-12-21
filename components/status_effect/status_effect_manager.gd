extends Node2D
class_name StatusEffectManager

signal status_effect_added(e: StatusEffect)

var _log = Logger.new("status_effect_mgr")
var effects: Array[StatusEffect]

func accept(v: Visitor):
    if v is StatusEffectManagerVisitor:
        v.visit_status_effect_manager(self)

func apply(node: Node = null):
    if not node:
        node = get_parent()
    if not node:
        return
    for e in effects:
        e.apply(node)

func handle(command: Command) -> Command:
    for e in effects:
        command = e.handle(command)
    return command

func has_effect(id: StringName) -> bool:
    for e in effects:
        if e.id == id:
            return true
    return false

func add_effect(effect: StatusEffect):
    _log.info("add: %s" % [effect])
    # add effect?
    match effect.type:
        StatusEffect.Type.STACKING:
            pass
            
        StatusEffect.Type.REFRESHING:
            if has_effect(effect.id):
                remove_effect(effect.id, true)
    effects.append(effect)
    # limited duration
    if effect.duration > -1:
        var i = effects.size() - 1
        var timer = Timer.new()
        timer.wait_time = effect.duration
        timer.timeout.connect(_on_effect_timeout.bind(i))
        add_child(timer)

func _on_effect_timeout(i: int):
    effects.remove_at(i)

func remove_effect(id: StringName, all: bool = false):
    _log.info("remove: %s" % [id])
    var removed = false
    for i in range(effects.size()-1, -1, -1):
        var e = effects[i]
        if e.id == id:
            effects.remove_at(i)
            removed = true
            if not all:
                return
    if not removed:
        _log.warn("did not find status effect: %s" % [id])
