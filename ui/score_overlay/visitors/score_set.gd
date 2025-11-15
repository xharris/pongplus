extends ScoreOverlayVisitor
class_name ScoreSet

enum Operation {SET, ADD, SUB}

@export var side: ScoreOverlay.Side
@export var operation: Operation
@export var value: int
@export var show: bool = true

var _log = Logger.new("score_set")#, Logger.Level.DEBUG)

func visit_score_overlay(me: ScoreOverlay):
    _log.debug("%s %d score %s" % [Operation.find_key(operation), value, ScoreOverlay.Side.find_key(side)])
    var score = me.get_score(side)
    match operation:
        Operation.SET:
            score = value
        Operation.ADD:
            score += value
        Operation.SUB:
            score -= value
    me.set_score(side, score, show)
