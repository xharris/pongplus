@tool
extends Node2D
class_name Character

enum AnimationName {NONE, ATTACK, BLOCK}
enum AnimationStep {NONE, ANTICIPATION, ACTIVE, RECOVERY}

signal animation_name_changed(animation: AnimationName)
signal animation_step_changed(step: AnimationStep)

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var sprite: Node2D = %Sprite
@onready var weapon_container: Node2D = %Weapon
@onready var arm_l: Node2D = %ArmL
@onready var arm_r: Node2D = %ArmR
@onready var head: Sprite2D = %Head
@onready var torso: Sprite2D = %Torso

var _log = Logger.new("character")#, Logger.Level.DEBUG)

@export var config: CharacterConfig:
    set(v):
        config = v
        update()
@export var animation_step: AnimationStep
@export var current_animation: AnimationName
## Allow holding an animation (charging)
@export var allow_hold: bool = true:
    set(v):
        if not v:
            release_hold()
        allow_hold = v
@export var weapon: PackedScene:
    set(v):
        if v and is_inside_tree():
            set_weapon(v.instantiate())

var _is_holding: bool = false
var _release_hold_requested: bool = false
var _hold_released: bool = false

var is_falling: bool
var is_hit: bool
var is_idle: bool
var is_walking: bool
var face_direction: Vector2

func accept(v: Visitor):
    if v is CharacterVisitor:
        v.visit_character(self)

func _process(delta: float) -> void:
    _check_release_hold()
    if not Engine.is_editor_hint():
        is_idle = !is_falling && !is_hit && !is_walking
        animation_tree["parameters/movement/conditions/is_falling"] = is_falling
        animation_tree["parameters/movement/conditions/is_hit"] = is_hit
        animation_tree["parameters/movement/conditions/is_idle"] = is_idle
        animation_tree["parameters/movement/conditions/is_walking"] = is_walking
        animation_tree["parameters/face_direction/blend_position"] = face_direction.x

func play_one_shot(animation_name: AnimationName):
    match animation_name:
        AnimationName.ATTACK:
            animation_tree["parameters/oneshot_attack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
        AnimationName.BLOCK:
            animation_tree["parameters/oneshot_block/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _ready() -> void:
    animation_player.speed_scale = 20
    animation_player.animation_finished.connect(_on_animation_finished)
    weapon = weapon
    update()

func _on_animation_finished(_anim_name: StringName):
    _release_hold_requested = false
    _set_animation_step(AnimationStep.NONE)
    #play_animation(AnimationName.NONE)
    
func set_weapon(node: Node2D):
    _log.info("set weapon_container: %s" % [node])
    for c in weapon_container.get_children():
        weapon_container.remove_child(c)
    weapon_container.add_child(node)
    
func is_holding() -> bool:
    return _is_holding

func release_hold():
    _release_hold_requested = true
    _check_release_hold()
  
func _check_release_hold():
    if _is_holding and _release_hold_requested:
        _log.debug("release hold")
        _is_holding = false
        #animation_player.speed_scale = 20
        animation_player.play(animation_player.current_animation)
        animation_player.advance(0)
  
#func play_animation(animation: AnimationName, only_resume: bool = false):
    #if only_resume and animation_player.current_animation_position <= 0:
        #return
    #match animation:
        #AnimationName.NONE:
            #animation_player.stop(true)
            #animation_player.play("RESET")
        #AnimationName.ATTACK:
            #animation_player.play("attack")
        #AnimationName.BLOCK:
            #animation_player.play("block")
        #AnimationName.HIT:
            #animation_player.play("hit") 
        #AnimationName.WALK:
            #animation_player.play("walk")
        #AnimationName.JUMP:
            #animation_player.play("jump")
        #AnimationName.FALL:
            #animation_player.play("fall")
    #if animation != current_animation:
        #animation_name_changed.emit(animation)
        #_log.debug("name: %s" % [AnimationName.find_key(animation)])
    #current_animation = animation
    
## For CallMethod track
func _set_animation_step(step: AnimationStep):
    animation_step = step
    animation_step_changed.emit(step)
    _log.debug("step: %s" % [AnimationStep.find_key(animation_step)])

## For CallMethod track
func _hold():
    if not allow_hold or _is_holding or _release_hold_requested:
        return
    var pos := animation_player.current_animation_position
    _log.debug("hold, frame: %f/%f" % [pos, animation_player.current_animation_length])
    animation_player.pause()
    _is_holding = true

func _step_anticipation():
    _set_animation_step(AnimationStep.ANTICIPATION)

func _step_active():
    _set_animation_step(AnimationStep.ACTIVE)
    
func _step_recovery():
    _set_animation_step(AnimationStep.RECOVERY)

func face_right():
    if sprite:
        sprite.scale.x = abs(sprite.scale.x)

func face_left():
    if sprite:
        sprite.scale.x = -abs(sprite.scale.x)

func set_weapon_color(color: Color = Color.WHITE, value: float = 0):
    var material: ShaderMaterial = weapon_container.material
    material.set_shader_parameter("flash_color", color)
    material.set_shader_parameter("flash_value", value)

func update():
    if not is_inside_tree():
        return
    if config:
        if config.spritesheet:
            head.texture = config.spritesheet
            torso.texture = config.spritesheet
        if config.hide_arms:
            arm_l.hide()
            arm_r.hide()
        else:
            arm_l.show()
            arm_r.show()
