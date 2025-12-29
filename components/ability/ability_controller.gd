extends Node2D
class_name AbilityController

signal accepted_visitor(v: Visitor)
signal instantiated(node: Node2D)

var _log = Logger.new("ability_ctrl")#, Logger.Level.DEBUG)
var abilities: Array[Ability]
## Passives + Currently queued ability
var active_abilities: Array[Ability]
var queue: Array[Ability]
var queue_index: int = 0
var _ability_ready_called: Dictionary
## TODO player sets this to weapon tip
var instantiate_position: Vector2

func accept(v: Visitor):
    if v is AbilityControllerVisitor:
        v.visit_ability_controller(self)
        update()
    else:
        accepted_visitor.emit(v)

func _ready() -> void:
    update()

func update():
    queue.clear()
    active_abilities.clear()
    for i in abilities.size():
        var a = abilities[i]
        match a.type:
            Ability.Type.QUEUED:
                queue.append(a)
                if i == queue_index:
                    active_abilities.append(a)
            Ability.Type.PASSIVE:
                active_abilities.append(a)
        # call on_ready
        if not _ability_ready_called.has(a.name):
            Visitor.visit(self, a.on_ready)
            _ability_ready_called.set(a.name, true)
    # forget on_ready calls for removed abilities
    for ability_name: StringName in _ability_ready_called:
        if not has_ability(ability_name):
            _ability_ready_called.erase(ability_name)
    _log.debug("active: %s" % [active_abilities.map(func(a: Ability): return a.name)])
        
func _process(delta: float) -> void:
    for a in active_abilities:
        Visitor.visit(self, a.on_process)

func has_ability(ability_name: StringName) -> bool:
    return abilities.any(func(a: Ability): return a.name == ability_name)

func attack_active():
    for a in active_abilities:
        Visitor.visit(self, a.on_attack_active)

func press_up():
    for a in active_abilities:
        Visitor.visit(self, a.on_press_up)

func health_take_damage():
    for a in active_abilities:
        Visitor.visit(self, a.on_health_take_damage)
