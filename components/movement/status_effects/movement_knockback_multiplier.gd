extends MovementStatusEffect
class_name MovementKnockbackMultiplier

@export var multiplier: float

func handle(cmd: MovementCommand) -> Command:
    if cmd is MovementKnockback:
        cmd.strength *= multiplier
    return cmd
