extends Node
class_name Groups

static var _log = Logger.new("groups")

const PLATFORM = &"platform"
const PLAYER_PLATFORM = &"player_platform"
const NODE_GROUP = &"node_group"
const MISSILE = &"missile"
const MISSILE_TARGET = &"missile_target"
const HITBOX = &"hitbox"
const BALL = &"ball"
const GAME = &"game"
const CAMERA = &"camera"
const PLAYER = &"player"
const SCORE_OVERLAY = &"score_overlay"
const TARGET = &"target"
const TRAINING_DUMMY = &"training_dummy"

const TEAM_PREFIX = &"team-"
const TEAM_NONE = &"team-none"

static var teams: Array[StringName] = []
static func TEAM(me: Node, index: int, remove_from_previous = true) -> StringName:
    # get team name
    index = max(0, index) 
    var group = &"team-%d" % (index)
    if not teams.has(group):
        teams.append(group)
    # remove from previous team(s)
    for g in teams:
        if me.is_in_group(g):
            _log.debug("%s remove from %s" % [me, g])
            me.remove_from_group(g)   
    # add to new team
    if not me.is_in_group(group):    
        _log.info("%s add to %s" % [me, group])
        me.add_to_group(group)
    return group

## Returns -1 if no team found
static func get_team(node: Node) -> StringName:
    var groups = node.get_groups()
    _log.debug("%s groups: %s" % [node, groups])
    for g in teams:
        if node.is_in_group(g):
            return g
    var parent = node.get_parent()   
    if parent:
        return get_team(parent)
    return TEAM_NONE
