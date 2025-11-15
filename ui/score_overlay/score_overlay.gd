extends Control
class_name ScoreOverlay

enum Side {LEFT, RIGHT}

@onready var label: Label = %Label

var _log = Logger.new("score")#, Logger.Level.DEBUG)
## [Side]int
var _score: Dictionary
var format_string: String = "{LEFT}-{RIGHT}"
var _tween: Tween

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
    # update score
    _score[side] = amount
    # convert scores to map [string]int
    var map: Dictionary
    for k in ScoreOverlay.Side.keys():
        map.set(k, _score.get(ScoreOverlay.Side[k], 0))
    _log.debug("scores: %s" % [map])
    # animate display (1)
    if show:
        _log.debug("show score")
        if _tween:
            _tween.stop()
            _tween = null
        # show current score
        label.modulate = Color(1,1,1,0.5)
        # BUG label.modulate is Color(1,1,1,0) here when it should be Color(1,1,1,0.5). This only happens the 2nd time this method is called.
        await get_tree().create_timer(0.5).timeout
    # update label
    label.text = format_string.format(map)
    # animate display (2)
    if show:
        # hide over time (animate label only)
        _tween = create_tween()
        _tween.tween_property(label, "modulate", Color(1,1,1,0), 1)
        _tween.play()
