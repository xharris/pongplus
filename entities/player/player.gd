extends Node2D
class_name Player

var _log = Logger.new("player")
    
@onready var movement: PlatformMovement = $PlatformMovement
@onready var controller: PlayerController = $PlayerController
@onready var hitbox: Hitbox = $Hitbox

@export var player_controller_config: PlayerControllerConfig
@export var abilities: Array[Ability]

func _ready() -> void:
    controller.config = player_controller_config
    
    movement.moved.connect(_on_moved)
    controller.up.connect(_on_up)
    controller.down.connect(_on_down)
    hitbox.body_entered_once.connect(_on_body_entered_once)

func _on_body_entered_once(body: Node2D):
    _log.debug("ouch, %s hit me." % [body])
    var parent = body.get_parent()
    if parent is Ball:
        for a in abilities:
            _log.debug("using ability %s" % [a.name])
            Visitor.visit(self, a.on_ball_hit_me)  
            Visitor.visit(parent, a.on_ball_hit_me)    

func _on_up():
    movement.move_up()

func _on_down():
    movement.move_down()

func _on_moved(platform: Platform):
    global_position = platform.global_position
