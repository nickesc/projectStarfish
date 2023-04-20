extends Obstacle

#export(String, "large_curly", "large_long", "large_puffy", "medium_2_hump", "medium_even", "medium_jumping", "small_giant_dwarf", "small_pill", "small_v") var shape = null
var shapes =  ["large_curly", "large_long", "large_puffy", "medium_2_hump", "medium_even", "medium_jumping", "small_giant_dwarf", "small_pill", "small_v"]
var shapes_reference = shapes
var curr_shape


func pick_shape():
    curr_shape = controller.random_from(shapes)
    sprite.play(curr_shape)
    return curr_shape

# Called when the node enters the scene tree for the first time.
func _ready():
    pick_shape()
