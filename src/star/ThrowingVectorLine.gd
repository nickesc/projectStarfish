extends Line2D

var length = 5

export var star_path: NodePath
var star: Star

func _ready():
    
    star = get_node(star_path)
    #star.throwing_vector_line = get_path()
    #add_point(Vector2.ZERO)
    #add_point(get_viewport().get_mouse_position())
    pass

func _process(delta):

    if points.size() > 0:
        if points.size() == 2:
            remove_point(1)
        add_point(get_viewport().get_mouse_position()/2 - star.position + (star.position - star.initial_position))

    pass
