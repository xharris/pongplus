@tool
extends Node2D
class_name VfxImpact

const _tool_config: VfxImpactConfig = preload("res://components/vfx_impact/vfx_impact_tool_config.tres")

@onready var particles: GPUParticles2D = %GPUParticles2D
@onready var _test_sprite: Sprite2D = $TestSprite2D

@export var show_editor_sprite: bool = true
var _log = Logger.new("vfx_impact")#, Logger.Level.DEBUG)
var _editor_squeeze_t: float = 0
var _original_scale: Vector2

func accept(v: Visitor):
    if v is VfxImpactVisitor:
        v.visit_vfx_impact(self)

func _ready() -> void:
    particles.emitting = false
    particles.one_shot = false
    if not Engine.is_editor_hint() or not show_editor_sprite:
        Util.destroy_free(_test_sprite)

func _process(delta: float) -> void:
    if Engine.is_editor_hint():
        #_test_sprite.rotation += PI * delta
        _editor_squeeze_t += delta
        if _editor_squeeze_t > 2:
            _editor_squeeze_t = 0
            do(_tool_config)

func do(config: VfxImpactConfig):
    _log.debug("do %s" % [config.resource_path.get_file()])
    # circle burst
    if config.circle_burst_enabled:
        var xform = Transform2D.IDENTITY
        xform = xform.translated(config.circle_burst_offset)
        xform = xform.translated(global_position)
        particles.emitting = true
        particles.process_material["color"] = config.circle_burst_color
        for _i in config.circle_burst_amount:
            particles.emit_particle(
                xform, Vector2.ZERO, config.circle_burst_color, config.circle_burst_color, 
                GPUParticles2D.EMIT_FLAG_POSITION|GPUParticles2D.EMIT_FLAG_COLOR
            )
        particles.emitting = false
    # squeeze
    if config.squeeze_enabled:
        var tween = create_tween()
        var from = Vector2(config.squeeze_amount, 1 / config.squeeze_amount).rotated(config.squeeze_rotation)
        tween.tween_property(self, "scale", Vector2.ONE, 0.2).from(from)
        tween.set_ease(Tween.EASE_OUT)
        await tween.finished
