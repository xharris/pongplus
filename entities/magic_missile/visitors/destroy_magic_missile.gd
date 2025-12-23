extends MagicMissileVisitor
class_name DestroyMagicMissile

func visit_magic_missile(me: MagicMissile):
    Util.destroy_free(me)
