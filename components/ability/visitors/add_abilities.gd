extends AbilityControllerVisitor
class_name AddAbilities

var _log = Logger.new("add_abilities")
@export var abilities: Array[Ability]

func visit_ability_controller(me: AbilityController):
    for a in abilities:
        if not me.has_ability(a.name):
            _log.info("add: %s" % [a.name])
            me.abilities.append(a)
        else:
            _log.info("already have: %s" % [a.name])
