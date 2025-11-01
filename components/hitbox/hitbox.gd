extends Area2D
class_name Hitbox

signal body_entered_once(body: Node2D)

var _log = Logger.new("hitbox")
@export var id: String
var _entered: Array[Node2D]

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
    area_entered.connect(_on_body_entered)
    area_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
    _log.debug("body entered: %s" % [body])
    if not _entered.has(body):
        _entered.append(body)
        body_entered_once.emit(body)

func _on_body_exited(body: Node2D):
    _entered.erase(body)

func disable():
    for c in find_children("*"):
        if c is CollisionShape2D:
            c.disabled = true
            
func enable():
    for c in find_children("*"):
        if c is CollisionShape2D:
            c.disabled = false
