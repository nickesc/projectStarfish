extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _on_Star_jumps_changed(jumps_left):
    var throws_format = "%d throws"
    
    if jumps_left == 1:
        throws_format = "%d throw"
    
    var throws_string = throws_format % int(jumps_left)
    
    text = throws_string
