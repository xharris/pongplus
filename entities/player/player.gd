extends Movement
class_name Player

enum AimDirection {STRAIGHT, UP, DOWN}
static var _i = 0

@onready var movement: Movement:
    get:
        return self
@onready var controller: PlayerController = %PlayerController
@onready var hitbox: Hitbox = %Hitbox
@onready var hurtbox: Hitbox = %Hurtbox
@onready var character: Character = %Character
@onready var camera: Camera = %Camera
@onready var health: Health = %Health
@onready var status_effects: StatusEffectManager = %StatusEffectManager

@export var player_controller_config: PlayerControllerConfig
@export var abilities: Array[Ability]
@export var team: int:
    set(v):
        Groups.TEAM(self, v, team)
        team = v
@export var layer: HitboxLayer
        
var aim_direction: AimDirection = AimDirection.STRAIGHT
## TODO move coyote to separate vfx node?
var coyote_distance = 140
var coyote_rate_of_change = 120
var coyote_time_scale = 1

var _platform_move_tween: Tween
var _ability_ready_called: Array[StringName]
var visitor_state: PlayerVisitor.State
var _delta: float = 0

func accept(v: Visitor):
    if v is PlayerVisitor:
        v.visit_player(self)
    elif v is CameraVisitor:
        camera.accept(v)
    elif v is CharacterVisitor:
        character.accept(v)
    elif v is HitboxVisitor:
        hitbox.accept(v)
    elif v is HealthVisitor:
        health.accept(v)
    elif v is MovementVisitor:
        v.visit_movement(self)
    else:
        accepted_visitor.emit(v)

func handle(cmd: Command):
    cmd = status_effects.handle(cmd)
    super.handle(cmd)

func _process(delta: float) -> void:
    super._process(delta)
    _delta = delta
    for a in abilities:
        visitor_state = PlayerVisitor.State.PROCESS
        Visitor.visit(self, a.on_process)
        visitor_state = PlayerVisitor.State.NONE
    movement.move = controller.move_direction
    #if controller.move_direction != Vector2.ZERO:
        #_log.debug("controller.move_direction=%s movement.velocity=%s" % [controller.move_direction, movement.velocity])
    if is_charge_locked():
        # attack charge coyote time when ball is nearby
        var closest: Missile
        var gp = global_position
        var coyote_distance_squared = coyote_distance ** 2
        for m: Missile in get_tree().get_nodes_in_group(Groups.MISSILE):
            var dist = gp.distance_squared_to(m.global_position)
            if dist < coyote_distance_squared and (
                not closest or \
                dist < gp.distance_squared_to(closest.global_position)\
            ):
                closest = m
        if closest:
            var charge_amount = Util.diminishing(
                0, # TODO controller.charge_duration / controller.max_charge_duration,
                coyote_rate_of_change
            )
            var dist_amount = Util.diminishing(
                max(0, coyote_distance - global_position.distance_to(closest.global_position)),
                coyote_rate_of_change
            )
            camera.time_scale = lerpf(1, coyote_time_scale, dist_amount) * lerpf(1, coyote_time_scale, charge_amount)
    else:
        camera.time_scale = 1.0
    _update()

func _init() -> void:
    _log.set_id("player")

func _ready() -> void:
    # Ensure player updates movement.move before Movement._process runs
    #process_priority = -1
    name = "Player%d" % [_i]
    _i += 1
    _log.set_prefix(name)
    add_to_group(Groups.PLAYER)
    team = team # trigger setter
    controller.config = player_controller_config
    hitbox.disable()
    
    health.current_changed.connect(_on_health_current_changed)
    #movement.accepted_visitor.connect(accept)
    controller.attack_charge.connect(_on_attack_charge)
    controller.attack_release.connect(_on_attack_release)
    controller.block_start.connect(_on_block_start)
    controller.block_stop.connect(_on_block_stop)
    controller.up.connect(_on_up)
    hurtbox.accepted_visitor.connect(accept)
    hurtbox.handled_command.connect(handle)
    hitbox.accepted_visitor.connect(accept)
    hitbox.handled_command.connect(handle)
    hitbox.body_entered_once.connect(_on_hitbox_body_entered_once)
    character.animation_step_changed.connect(_on_character_animation_step_changed)

    _update()
    
func _on_block_start():
    if not is_animation_locked():
        character.play_animation(Character.AnimationName.BLOCK)

func _on_block_stop():
    if is_block_locked():
        character.release_hold()
    
func _on_character_animation_step_changed(step: Character.AnimationStep):
    match character.current_animation:
        Character.AnimationName.ATTACK:
            match step:
                Character.AnimationStep.ACTIVE:
                    hitbox.enable()
                    character.set_weapon_color(Color.WHITE, 0.8)
                    for a in abilities:
                        Visitor.visit(self, a.on_attack_active)
                Character.AnimationStep.RECOVERY:
                    hitbox.disable()
                    character.set_weapon_color(Color.WHITE, 0)
    
func _on_up():
    for a in abilities:
        Visitor.visit(self, a.on_press_up)
    
func _on_health_current_changed(amount: int):
    if amount < 0:
        for a in abilities:
            Visitor.visit(self, a.on_health_take_damage)
    EventBus.player_health_current_changed.emit(self, amount)

func _on_attack_charge():
    if not is_block_locked() and not is_attack_locked():
        character.play_animation(Character.AnimationName.ATTACK)

func _on_attack_release():
    if is_charge_locked() and is_attack_locked():
        # continue attack animation
        character.release_hold()

func _on_hitbox_body_entered_once(body: Node2D):
    if body is Hitbox:
        var parent = body.get_parent()
        if parent and Util.find_child(parent, Missile):
            var visitors: Array[Visitor]
            for a in abilities:
                visitors.append_array(a.on_me_hit_missile)
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
            _log.debug("me hit %s (%s), %d visitor(s)" % [parent, AimDirection.find_key(aim_direction), visitors.size()])
            Visitor.visit(self, visitors)
            Visitor.visit(body, visitors)
            aim_direction = AimDirection.STRAIGHT

func is_animation_locked():
    return character.current_animation != Character.AnimationName.NONE

## Is currently in the middle of an attack
func is_attack_locked():
    return \
        character.current_animation == Character.AnimationName.ATTACK

## Is currently charging an attack
func is_charge_locked():
    return character.is_holding()

func is_block_locked():
    return character.current_animation == Character.AnimationName.BLOCK

## Is locked out of moving
func is_movement_locked():
    return false

func _update():
    _log.set_prefix(name)
    health._log.set_prefix(name)
    movement._log.set_prefix(name)
    hitbox._log.set_prefix(name)
    hurtbox._log.set_prefix(name)
    character._log.set_prefix(name)
    camera._log.set_prefix(name)
    health._log.set_prefix(name)
    for a in abilities:
        if not _ability_ready_called.has(a.name):
            # new ability added
            visitor_state = PlayerVisitor.State.READY
            Visitor.visit(self, a.on_ready)
            visitor_state = PlayerVisitor.State.NONE
            movement.visitors.append_array(a.movement)
            _ability_ready_called.append(a.name)
    layer.update(self)
