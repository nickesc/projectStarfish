extends Label

var jumps_format = "%d jumps"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _on_Star_jumps_changed(jumps_left):
    var jumps_string = jumps_format % int(jumps_left)
    
    text = jumps_string
    #text=jumps_left
