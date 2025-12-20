extends Resource
class_name StatusEffect

@export var id: StringName

func apply(me):
    pass
    
func handle(cmd) -> Command:
    return cmd
