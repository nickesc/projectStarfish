extends Line2D

var length = 5


func _ready():
    #add_point(Vector2.ZERO)
    #add_point(get_viewport().get_mouse_position())
    pass

func _process(delta):

    if points.size() > 0:
        if points.size() == 2:
            remove_point(1)
        add_point(get_viewport().get_mouse_position()/2 - owner.position + (owner.position - owner.initial_position) + Vector2(0,20))

    pass
