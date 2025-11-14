extends Resource
class_name Ability

static func has_ability(abilities: Array[Ability], ability: Ability) -> bool:
    for a in abilities:
        if a.name == ability.name:
            return true
    return false

@export var name: StringName
@export var on_ready: Array[Visitor]

@export var on_me_hit_missile: Array[Visitor]
@export var on_me_hit_missile_straight: Array[Visitor]
@export var on_me_hit_missile_up: Array[Visitor]
@export var on_me_hit_missile_down: Array[Visitor]

@export var on_me_hit_player: Array[Visitor]

@export var on_health_take_damage: Array[Visitor]

@export var on_me_hit_player_platform: Array[Visitor]
