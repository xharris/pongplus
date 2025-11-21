extends VfxImpactVisitor
class_name VfxImpactDo

@export var configs: Array[VfxImpactConfig]

func visit_vfx_impact(me: VfxImpact):
    for c in configs:
        me.do(c)
