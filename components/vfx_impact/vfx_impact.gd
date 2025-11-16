extends Node2D
class_name VfxImpact

@onready var particles: GPUParticles2D = %GPUParticles2D

func _ready() -> void:
    particles.emitting = false
    particles.one_shot = false
    
func circle_burst(pos: Vector2, color: Color = Color.BLACK, amount: int = 3):
    var xform = Transform2D.IDENTITY
    xform = xform.translated(pos)
    particles.emitting = true
    for _i in amount:
        particles.emit_particle(
            xform, Vector2.ZERO, color, color, 
            GPUParticles2D.EMIT_FLAG_POSITION|GPUParticles2D.EMIT_FLAG_COLOR
        )
    particles.emitting = false
