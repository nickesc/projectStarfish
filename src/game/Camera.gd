extends Camera2D


export var star_path: NodePath
var star: Star

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
   star = get_node(star_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    position = star.position + Vector2(299,-77)
