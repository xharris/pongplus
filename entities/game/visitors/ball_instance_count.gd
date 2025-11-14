extends GameVisitor
class_name BallInstanceCount

enum Operation {Set, AtLeast}

var _log = Logger.new("ball_instance_count", Logger.Level.DEBUG)
@export var operation: Operation
@export var value: int

func visit_game(me: Game):
    var ball_count = 0
    for b: Ball in me.get_tree().get_nodes_in_group(Groups.BALL):
        ball_count += 1
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
        
    _log.debug("found %d balls. %s %d ball(s)" % [ball_count, "add" if add else "remove", abs(diff)])
    var view_size = me.get_viewport_rect()
    for i in abs(diff):
        if add:
            var ball: Ball = Ball.SCENE.instantiate()
            me.add_child.call_deferred(ball)
        else:
            var ball: Ball = me.get_tree().get_first_node_in_group(Groups.BALL)
            Util.destroy_free(ball)
