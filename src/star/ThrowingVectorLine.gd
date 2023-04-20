extends Line2D

var length = 5

export var star_path: NodePath
var star: Star

func _ready():
    
    star = get_node(star_path)
    pass

func _process(delta):

    if points.size() > 0:
        if points.size() == 2:
            remove_point(1)
        
        var point = star.throwing_vector_line.get_local_mouse_position()
        
        point.x = clamp(point.x, 0, star.screen_size.x/2)
        point.y = clamp(point.y, 0, star.screen_size.y/2)
        
        add_point(point)

    pass
