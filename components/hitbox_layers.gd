extends Resource
class_name HitboxLayer

enum Layer {NONE=0, ANY=1, HITBOX=2, HURTBOX=3, SURFACE=4}

var _log = Logger.new("hitbox_layer")
@export var layer: Layer
@export var collide_with: Array[Layer]
## Will only be called for Area2D
@export var on_collide: Array[Visitor]

var _last_layer: Layer

func update(me: CollisionObject2D):
    # enable collision detection with other layers
    for l in Layer.values():
        if l == Layer.NONE:
            continue
        me.set_collision_mask_value(l, layer != Layer.NONE and collide_with.has(l) or collide_with.has(Layer.ANY))
    if _last_layer == layer:
        return
    _last_layer = layer
    # place this hitbox in layer
    for l in Layer.values():
        if l == Layer.NONE:
            continue
        me.set_collision_layer_value(l, l == layer or l == Layer.ANY)
    _log.info("%s, layers: %s, masks: %s" % [
        me,
        Layer.find_key(layer),
        collide_with.map(func (l: Layer): return Layer.find_key(l))
    ])
    
