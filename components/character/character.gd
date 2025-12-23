extends Node2D
class_name Character

enum AnimationName {NONE, ATTACK, BLOCK, HIT}
enum AnimationStep {NONE, ANTICIPATION, ACTIVE, RECOVERY}

const ANIMATION_NAMES = {
    "attack": AnimationName.ATTACK,
    "block": AnimationName.BLOCK,
    "hit": AnimationName.HIT,
}

signal animation_name_changed(animation: AnimationName)
signal animation_step_changed(step: AnimationStep)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Node2D = %Sprite
@onready var weapon: Node2D = %Weapon

var _log = Logger.new("character")#, Logger.Level.DEBUG)

@export var animation_step: AnimationStep
@export var current_animation: AnimationName
## Allow holding an animation (charging)
@export var allow_hold: bool = true:
    set(v):
        if not v:
            release_hold()
        allow_hold = v
        
var _is_holding: bool = false
var _release_hold_requested: bool = false
var _hold_released: bool = false

func accept(v: Visitor):
    if v is CharacterVisitor:
        v.visit_character(self)

func _process(delta: float) -> void:
    _check_release_hold()

func _ready() -> void:
    animation_player.speed_scale = 20
    animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_anim_name: StringName):
    _release_hold_requested = false
    _set_animation_step(AnimationStep.NONE)
    play_animation(AnimationName.NONE)
    
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
  
func play_animation(animation: AnimationName, only_resume: bool = false):
    if only_resume and animation_player.current_animation_position <= 0:
        return
    match animation:
        AnimationName.NONE:
            animation_player.stop(true)
            animation_player.play("RESET")
        AnimationName.ATTACK:
            animation_player.play("attack")
        AnimationName.BLOCK:
            animation_player.play("block")
        AnimationName.HIT:
            animation_player.play("hit") 
    if animation != current_animation:
        animation_name_changed.emit(animation)
        _log.debug("name: %s" % [AnimationName.find_key(animation)])
    current_animation = animation
    
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
    sprite.scale.x = 1
    
func face_left():
    sprite.scale.x = -1

func set_weapon_color(color: Color = Color.WHITE, value: float = 0):
    var material: ShaderMaterial = weapon.material
    material.set_shader_parameter("flash_color", color)
    material.set_shader_parameter("flash_value", value)
