extends Control
class_name ScoreOverlay

enum Side {LEFT, RIGHT}

@onready var label: Label = %Label

var _log = Logger.new("score", Logger.Level.DEBUG)
## [Side]int
var _score: Dictionary

func accept(v: Visitor):
    if v is ScoreOverlayVisitor:
        v.visit_score_overlay(self)

func _ready() -> void:
    add_to_group(Groups.SCORE_OVERLAY)
    reset()
    
func reset():
    for side in _score:
        _score[side] = 0
    label.modulate.a = 0

func get_score(side: ScoreOverlay.Side) -> int:
    return _score.get(side, 0)

func set_score(side: ScoreOverlay.Side, amount: int, show: bool = true):
    _log.debug("set score for %s: %d" % [ScoreOverlay.Side.find_key(side), amount])
    var tween: Tween
    if show:
        tween = create_tween()
        # show current score
        label.modulate = Color(1,1,1,0.5)
        await get_tree().create_timer(1).timeout
    # update score
    _score[side] = amount
    var scores: Array[int]
    scores.assign(_score.values())
    label.text = "-".join(scores)
    if show:
        # hide over time
        tween.tween_property(self, "modulate", Color(1,1,1,0), 1)
