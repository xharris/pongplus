extends Node2D
class_name Player

enum BallDirection {STRAIGHT, UP, DOWN}

var _log = Logger.new("player")#, Logger.Level.DEBUG)

@onready var movement: PlatformMovement = $PlatformMovement
@onready var controller: PlayerController = $PlayerController
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hitbox = $Hurtbox
@onready var character: Character = $Character

@export var player_controller_config: PlayerControllerConfig
@export var abilities: Array[Ability]

var ball_hit_direction: BallDirection = BallDirection.STRAIGHT
var hitbox_timer: Timer

func accept(v: Visitor):
    if v is PlayerVisitor:
        v.visit_player(self)

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

    for a in abilities:
        Visitor.visit(self, a.on_ready)

func _on_hurtbox_body_entered_once(body: Node2D):
    var parent = body.get_parent()
    if parent is Ball:
        for a in abilities:
            _log.debug("%s hit me" % [parent])
            Visitor.visit(self, a.on_ball_hit_me)
            Visitor.visit(parent, a.on_ball_hit_me)

func _on_charge_attack():
    character.charge_attack()

func _on_release_attack():
    # play swing animation
    character.attack()
    # enable hitbox for X seconds
    hitbox.enable()
    hitbox_timer = Timer.new()
    hitbox_timer.timeout.connect(_on_hitbox_timer_timeout)
    hitbox_timer.wait_time = Constants.ATTACK_HITBOX_ACTIVE_DURATION
    add_child(hitbox_timer)
    hitbox_timer.start()
    hitbox.update_indicator(0)

func _on_hitbox_timer_timeout():
    hitbox_timer = null
    hitbox.disable()

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
        var index_in_group = platform.index_in_group()
        if index_in_group < 0:
            _log.warn("current platform is not in a group")
            return
        # get a different group
        var groups: Array[Platform.Group]
        for g in Platform.groups:
            if g.index != platform.group_index:
                groups.append(g)
        if groups.is_empty():
            _log.warn("no other platform groups found")
            return
        
        var group: Platform.Group = groups.pick_random()
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

## Is currently in the middle of an attack
func is_attack_locked():
    return controller.is_charging or character.is_attacking()

## Is currently charging an attack
func is_charge_attack_locked():
    return controller.is_charging

## Is locked out of moving
func is_movement_locked():
    return controller.is_charging or \
        character.is_attacking() or \
        (hitbox_timer != null and hitbox_timer.time_left > 0)

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
