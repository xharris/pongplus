## Should be used in on_ready only
extends PlayerVisitor
class_name PlayerMagicMissile

var _log = Logger.new("player_magic_missile")

func visit_player(me: Player):
    _log.set_prefix(me.name)
    match me.visitor_state:
        State.READY:
            pass
        State.PROCESS:
            # face direction
            var view_center = me.get_viewport_rect().get_center()
            if me.global_position.x > view_center.x:
                me.character.face_left()
            elif me.global_position.x < view_center.x:
                me.character.face_right()
        _:
            return _log.warn("visitor %s should only be called in on_ready/on_process" % [resource_path])
    
