extends Node2D
class_name Player

enum AimDirection {STRAIGHT, UP, DOWN}

var _log = Logger.new("player")#, Logger.Level.DEBUG)

@onready var movement: PlatformMovement = $PlatformMovement
@onready var controller: PlayerController = $PlayerController
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hitbox = $Hurtbox
@onready var character: Character = $Character
@onready var camera: Camera = $Camera
@onready var health: Health = $Health

@export var player_controller_config: PlayerControllerConfig
@export var abilities: Array[Ability]

var _platform_move_tween: Tween
var aim_direction: AimDirection = AimDirection.STRAIGHT
var _ability_ready_called: Array[StringName]

func accept(v: Visitor):
    if v is CameraVisitor:
        camera.accept(v)
    elif v is CharacterVisitor:
        character.accept(v)
    elif v is HitboxVisitor:
        hitbox.accept(v)
    elif v is HealthVisitor:
        health.accept(v)

func _process(delta: float) -> void:
    # face direction
    var view_center = get_viewport_rect().get_center()
    if global_position.x > view_center.x:
        character.face_left()
    else:
        character.face_right()
    # attack charge indicator
    if controller.is_charging:
        hitbox.update_indicator(controller.charge_duration / controller.max_charge_duration)
    _update()

func _ready() -> void:
    add_to_group(Groups.PLAYER)
    controller.config = player_controller_config
    hitbox.disable()
    
    health.current_changed.connect(_on_health_current_changed)
    movement.moved.connect(_on_moved)
    controller.up.connect(_on_up)
    controller.down.connect(_on_down)
    controller.charge_attack.connect(_on_charge_attack)
    controller.release_attack.connect(_on_release_attack)
    hitbox.accepted_visitor.connect(accept)
    hitbox.body_entered_once.connect(_on_hitbox_body_entered_once)
    character.attack_window_start.connect(_on_attack_window_start)
    character.attack_window_end.connect(_on_attack_window_end)

    _update()

func _on_health_current_changed(amount: int):
    if amount < 0:
        for a in abilities:
            Visitor.visit(self, a.on_health_take_damage)
    EventBus.player_health_current_changed.emit(self, amount)

func _on_attack_window_start():
    hitbox.enable()
    character.set_weapon_color(Color.WHITE, 0.8)

func _on_attack_window_end():
    hitbox.disable()
    character.set_weapon_color(Color.WHITE, 0)

func _on_charge_attack():
    if not is_attack_locked():
        character.charge_attack()

func _on_release_attack():
    # play swing animation
    character.attack()
    # hide indicator
    hitbox.update_indicator(0)

func _on_hitbox_body_entered_once(body: Node2D):
    if body is Hitbox:
        var parent = body.get_parent()
        if parent:
            var visitors: Array[Visitor]
            match aim_direction:
                AimDirection.UP:
                    for a in abilities:
                        visitors.append_array(a.on_me_hit_missile_up)
                AimDirection.DOWN:
                    for a in abilities:
                        visitors.append_array(a.on_me_hit_missile_down)
                AimDirection.STRAIGHT:
                    for a in abilities:
                        visitors.append_array(a.on_me_hit_missile_straight)
            _log.debug("me hit %s, %d visitor(s)" % [parent, visitors.size()])
            Visitor.visit(self, visitors)
            Visitor.visit(parent, visitors)
            aim_direction = AimDirection.STRAIGHT

## Is currently in the middle of an attack
func is_attack_locked():
    return controller.is_charging or character.is_attacking()

## Is currently charging an attack
func is_charge_attack_locked():
    return controller.is_charging

## Is locked out of moving
func is_movement_locked():
    return controller.is_charging or character.is_attacking()

func _on_up():
    if is_charge_attack_locked():
        aim_direction = AimDirection.UP
    if not is_movement_locked():
        movement.move_up()

func _on_down():
    if is_charge_attack_locked():
        aim_direction = AimDirection.DOWN
    if not is_movement_locked():
        movement.move_down()

func _on_moved(platform: Platform):
    if _platform_move_tween:
        _platform_move_tween.stop()
    _platform_move_tween = create_tween()
    _platform_move_tween.tween_property(self, "global_position", platform.global_position, 0.1)

func _update():
    for a in abilities:
        if not _ability_ready_called.has(a.name):
            Visitor.visit(self, a.on_ready)
            _ability_ready_called.append(a.name)
