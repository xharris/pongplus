extends Node2D
class_name Player

enum BallDirection {STRAIGHT, UP, DOWN}

var _log = Logger.new("player")#, Logger.Level.DEBUG)

@onready var movement: PlatformMovement = $PlatformMovement
@onready var controller: PlayerController = $PlayerController
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hitbox = $Hurtbox
@onready var character: Character = $Character
@onready var camera: Camera = $Camera

@export var player_controller_config: PlayerControllerConfig
@export var abilities: Array[Ability]

var ball_hit_direction: BallDirection = BallDirection.STRAIGHT

func accept(v: Visitor):
    camera.accept(v)
    character.accept(v)

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

func _ready() -> void:
    controller.config = player_controller_config
    hitbox.disable()
    
    movement.moved.connect(_on_moved)
    controller.up.connect(_on_up)
    controller.down.connect(_on_down)
    controller.charge_attack.connect(_on_charge_attack)
    controller.release_attack.connect(_on_release_attack)
    hitbox.body_entered_once.connect(_on_hitbox_body_entered_once)
    hurtbox.body_entered_once.connect(_on_hurtbox_body_entered_once)
    character.attack_window_start.connect(_on_attack_window_start)
    character.attack_window_end.connect(_on_attack_window_end)

    for a in abilities:
        Visitor.visit(self, a.on_ready)

func _on_attack_window_start():
    hitbox.enable()
    character.set_weapon_color(Color.WHITE, 0.8)

func _on_attack_window_end():
    hitbox.disable()
    character.set_weapon_color(Color.WHITE, 0)

func _on_hurtbox_body_entered_once(body: Node2D):
    var parent = body.get_parent()
    if parent is Ball:
        for a in abilities:
            _log.debug("%s hit me" % [parent])
            Visitor.visit(self, a.on_ball_hit_me)
            Visitor.visit(parent, a.on_ball_hit_me)

func _on_charge_attack():
    if not is_attack_locked():
        character.charge_attack()

func _on_release_attack():
    # play swing animation
    character.attack()
    # hide indicator
    hitbox.update_indicator(0)

func _on_hitbox_body_entered_once(body: Node2D):
    var parent = body.get_parent()
    if parent is Ball:
        _log.debug("I hit %s" % [parent])
        # get last platform targeted
        var targets = parent.missile.target_history.duplicate()
        targets.reverse()
        var platform: Platform
        for t in targets:
            var p: Platform = Util.get_ancestor(t, Platform)
            if p:
                platform = p
                break
        if not platform:
            _log.warn(
                "no previously targeted platform:\n\tmissile.target_history: %s" % [
                    parent.missile.target_history
                ])
            return
        # get same index platform in group
        var last_group = PlatformGroup.get_group(platform)
        if not last_group:
            _log.warn("platform is not part of a group: %s" % [platform])
            return
        var groups: Array[PlatformGroup]
        groups.assign(get_tree().get_nodes_in_group(Groups.PLATFORM_GROUP))
        groups.erase(last_group)        
        var group: PlatformGroup = groups.pick_random()
        var index_in_group = last_group.platforms.find(platform)
        var opposite_platform = group.platforms[clampi(index_in_group, 0, group.platforms.size()-1)]
        # get next platform to target
        match ball_hit_direction:
            BallDirection.UP when opposite_platform.up:
                parent.next_missile_target = opposite_platform.up
            BallDirection.DOWN when opposite_platform.down:
                parent.next_missile_target = opposite_platform.down
            _:
                parent.next_missile_target = opposite_platform
        # move to it
        _log.debug("Ball next target: from %s to %s" % [platform, parent.next_missile_target])
        parent.missile_path_next_target()
        for a in abilities:
            _log.debug("using ability %s" % [a.name])
            Visitor.visit(self, a.on_me_hit_ball)  
            Visitor.visit(parent, a.on_me_hit_ball)
    ball_hit_direction = BallDirection.STRAIGHT

## Is currently in the middle of an attack
func is_attack_locked():
    return controller.is_charging or (character.is_attacking() and not character.attack_window_ended)

## Is currently charging an attack
func is_charge_attack_locked():
    return controller.is_charging

## Is locked out of moving
func is_movement_locked():
    return controller.is_charging or \
        (character.is_attacking() and not character.attack_window_ended)

func _on_up():
    if is_charge_attack_locked():
        ball_hit_direction = BallDirection.UP
    if not is_movement_locked():
        movement.move_up()

func _on_down():
    if is_charge_attack_locked():
        ball_hit_direction = BallDirection.DOWN
    if not is_movement_locked():
        movement.move_down()

func _on_moved(platform: Platform):
    global_position = platform.global_position
