extends CharacterBody2D
class_name Floor

@export var layer: HitboxLayer

var _log = Logger.new("floor")
var _collided: Dictionary

func _ready() -> void:
    if layer:
        layer.update(self)

func _physics_process(delta: float) -> void:
    var still_colliding: Dictionary
    # react to body collision
    #for body in get_colliding_bodies():
        #_log.info("collide: %s" % [body.name])
        #still_colliding[body] = true
        #if not _collided[body]:
            #_collided[body] = true
            #Visitor.visit(body, layer.on_collide)
    ## check if body has stopped colliding
    #for body in _collided.keys():
        #if not still_colliding:
            #_collided[body] = true
