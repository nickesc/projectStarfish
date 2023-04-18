extends Label

var position_format = "%.1f m"
onready var star = get_tree().current_scene.get_node("Star")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Star_max_position_change(new_max_position):
    new_max_position = new_max_position.x * 10
    new_max_position = round(new_max_position)
    new_max_position = float(new_max_position / 10)
    
    new_max_position = new_max_position / star.pixel_to_meter_conversion_factor
    
     
    var max_position_string = position_format % new_max_position
    
    text = max_position_string
