extends TargetStrategy
class_name TeamTargetStrategy

enum Type {ENEMY, ALLY, SELF}

var _log = Logger.new("team_target_strategy")
@export var type: Type = Type.ENEMY

func get_target(me: Node2D = null) -> Node2D:
    if not me:
        _log.warn("no source node provided")
        return
    # get current team
    var current_team = Groups.get_team(me)
    if current_team == Groups.TEAM_NONE:
        _log.warn("not part of team: %s" % [me])
        return
    # get another team
    var other_teams = Groups.teams.duplicate()
    other_teams.erase(current_team)
    if other_teams.size() == 0:
        _log.warn("no other teams")
        return
    # get a random node in that team
    var target_team = other_teams.pick_random()
    var nodes: Array[Node2D]
    nodes.assign(me.get_tree().get_nodes_in_group(target_team))
    if nodes.size() == 0:
        _log.warn("nobody on other team: %s" % [target_team])
        return
    var target = nodes.pick_random()
    _log.debug("target %s (%s)" % [target, Type.find_key(type)])
    return target
