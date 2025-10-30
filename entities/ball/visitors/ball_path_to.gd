extends BallVisitor
class_name BallPathTo

enum Target {
    PLATFORM,
    PLATFORM_UP,
    PLATFORM_DOWN
}

var _log = Logger.new("ball_path_to")
@export var target: Target
@export var offset: int

func visit_ball(me: Ball):
    match target:
        Target.PLATFORM, Target.PLATFORM_UP, Target.PLATFORM_DOWN:
            # get 2nd to last platform targeted
            var targets = me.missile.target_history.duplicate()
            targets.reverse()
            var platform: Platform
            for t in targets:
                var p: Platform = Util.get_ancestor(t, Platform)
                if p:
                    platform = p
                    break
            if not platform:
                _log.warn(
                    "no previously targeted platform:\n\tmissile.target_history: %s" % [
                        me.missile.target_history
                    ])
                return
            # get same index platform in group
            var index_in_group = platform.index_in_group()
            if index_in_group < 0:
                _log.warn("current platform is not in a group")
                return
            # get a different group
            var groups: Array[Platform.Group]
            for g in Platform.groups:
                if g.index != platform.group_index:
                    groups.append(g)
            if groups.is_empty():
                _log.warn("no other platform groups found")
                return
            var group: Platform.Group = groups.pick_random()
            var next_platform = group.platforms[clampi(index_in_group, 0, group.platforms.size()-1)]
            # get next platform to target
            match target:
                Target.PLATFORM_UP when next_platform.up:
                    next_platform = next_platform.up
                Target.PLATFORM_DOWN when next_platform.down:
                    next_platform = next_platform.down
            # move to it
            _log.debug("move from %s to %s" % [platform, next_platform])
            me.missile.path_to(next_platform)
