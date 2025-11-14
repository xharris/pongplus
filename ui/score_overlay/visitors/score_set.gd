extends ScoreOverlayVisitor
class_name ScoreSet

enum Operation {SET, ADD, SUB}

@export var side: ScoreOverlay.Side
@export var operation: Operation
@export var value: int
@export var show: bool = true

func visit_score_overlay(me: ScoreOverlay):
    var score = me.get_score(side)
    match operation:
        Operation.SET:
            score = value
        Operation.ADD:
            score += value
        Operation.SUB:
            score -= value
    me.set_score(side, score, show)
