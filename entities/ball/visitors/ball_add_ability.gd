extends BallVisitor
class_name BallAddAbility

var _log = Logger.new("ball_add_ability")#, Logger.Level.DEBUG)

@export var ability: Ability

func visit_ball(me: Ball):
    _log.debug("add %s" % [ability.name])
    me.abilities.append(ability)
