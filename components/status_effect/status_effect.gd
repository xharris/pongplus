extends Resource
class_name StatusEffect

enum Type {STACKING, REFRESHING}

@export var id: StringName
@export var type: Type
## -1 = infinite (until removed)
@export var duration: float = -1

func apply(me):
    pass
    
func handle(cmd) -> Command:
    return cmd
