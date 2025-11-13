extends SceneVisitor
class_name BallInstanceCount

enum Operation {Set, AtLeast}

var _log = Logger.new("ball_instance_count")#, Logger.Level.DEBUG)
@export var operation: Operation
@export var value: int

func visit_current_scene(me: Node):
    var ball_count = me.get_tree().get_node_count_in_group(Groups.BALL)
    var diff = value - ball_count
    if diff == 0:
        return
    var modify = false
    var add = false
    
    match operation:
        Operation.Set when diff != 0:
            modify = true
            add = diff > 0
        Operation.AtLeast when diff > 0:
            modify = true
            add = diff > 0
        
    _log.debug("%s %d balls" % ["add" if add else "remove", abs(diff)])
    var view_size = me.get_viewport_rect()
    for i in abs(diff):
        if add:
            var ball: Ball = Ball.SCENE.instantiate()
            me.add_child(ball)
        else:
            var ball: Ball = me.get_tree().get_first_node_in_group(Groups.BALL)
            var parent = ball.get_parent()
            if parent:
                parent.remove_child(ball)
            ball.queue_free()
