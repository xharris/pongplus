extends MovementStatusEffect
class_name MovementKnockbackResist

func handle(cmd: MovementCommand) -> Command:
    if cmd is MovementKnockback:
        cmd.strength /= 2
    return cmd
