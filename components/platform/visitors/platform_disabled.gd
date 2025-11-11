extends PlatformVisitor
class_name PlatformDisabled

@export var disabled: bool = false

func visit_platform(me: Platform):
    if disabled:
        me.disable()
    else:
        me.enable()
