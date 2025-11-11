extends Control
class_name ScoreOverlay

@onready var label: Label = %Label

func _ready() -> void:
    reset()
    
func reset():
    label.text = "0-0"
    label.modulate.a = 0

func set_score(left: int, right: int):
    var tween = create_tween()
    # show current score
    label.modulate = Color(1,1,1,0.5)
    await get_tree().create_timer(1).timeout
    # update score
    label.text = "%d-%d" % [left, right]
    # show 
    tween.tween_property(self, "modulate", Color(1,1,1,0), 1)
