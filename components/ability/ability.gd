extends Resource
class_name Ability

static var _static_log = Logger.new("ability")#, Logger.Level.DEBUG)

static func has_ability(abilities: Array[Ability], ability: Ability) -> bool:
    for a in abilities:
        if a.name == ability.name:
            return true
    return false

static var _ability_ready_called: Dictionary


static func visit_abilities(abilities: Array[Ability], node: Node, name: StringName):
    var ready_called: Array[StringName]
    ready_called.assign(_ability_ready_called.get(node, []))
    # iter in reverse order to simulate overriding abilities
    # (ability at end of array overrides visitors that come before it in array)
    for i in range(abilities.size()-1, -1, -1):
        var a: Ability = abilities[i]
        if not a.get_property_list().any(func(pl: Dictionary): return pl.get("name", "") == name):
            _static_log.warn("invalid ability property: %s" % [name])
            break
        var visitors: Array[Visitor]
        # only call on_ready once
        match name:
            ON_READY when ready_called.has(a.name):
                continue
        _static_log.debug("visit %s" % [a.name])
        # get visitors
        visitors.assign(a.get(name))
        if visitors.size() > 0:
            Visitor.visit(node, visitors)
            match name:
                ON_READY:
                    ready_called.append(a.name)
            # BUG not working
            if a.overrides:
                _static_log.debug("override at %s.%s, stop processing abilities" % [a.name, name])
                break # stop processing abilities
    _ability_ready_called.set(node, ready_called)

const ON_READY = &"on_ready"
const ON_ME_HIT_PLAYER = &"on_me_hit_player"
const ON_ME_HIT_PLAYER_PLATFORM = &"on_me_hit_player_platform"

@export var name: StringName
## When [code]true[/code], if this ability is last in the list,
## it's visitors will be called and abilities higher in the list will
## be skipped. This will not happen though if the visitor array is empty.
@export var overrides: bool = true

@export var on_ready: Array[Visitor]
@export var on_process: Array[Visitor]

@export var on_me_hit_missile: Array[Visitor]
@export var on_me_hit_missile_straight: Array[Visitor]
@export var on_me_hit_missile_up: Array[Visitor]
@export var on_me_hit_missile_down: Array[Visitor]
@export var on_me_hit_player: Array[Visitor]
@export var on_me_hit_player_platform: Array[Visitor]

@export var on_health_take_damage: Array[Visitor]
@export var on_press_up: Array[Visitor]

@export var on_attack_active: Array[Visitor]

@export var movement: Array[Visitor]
