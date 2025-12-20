extends StatusEffect
class_name MovementStatusEffect

func apply(me: Movement):
    pass
    
func handle(cmd: MovementCommand) -> Command:
    return cmd
