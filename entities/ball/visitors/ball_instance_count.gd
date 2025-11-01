extends BallVisitor
class_name BallInstanceCount

enum Operation {Set}

var _log = Logger.new("ball_instance_count")
@export var operation: Operation
@export var value: int

func visit_ball(me: Ball):
    var diff = value - me.get_tree().get_node_count_in_group(Groups.BALL)
    var modify = false
    var add = false
    
    match operation:
        Operation.Set when diff != 0:
            modify = true
            add = diff > 0
        
    _log.debug("%s %d balls" % ["add" if add else "remove", abs(diff)])
    var game: Node2D = me.get_tree().get_first_node_in_group(Groups.GAME)
    var view_size = me.get_viewport_rect()
    for i in abs(diff):
        if add:
            var ball: Ball = Ball.SCENE.instantiate()
            ball.global_position = view_size.get_center()
            game.add_child(game)
        else:
            var ball: Ball = me.get_tree().get_first_node_in_group(Groups.BALL)
            var parent = ball.get_parent()
            if parent:
                parent.remove_child(ball)
            ball.queue_free()
