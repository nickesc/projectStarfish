extends Label

var shells_format = "x%04d"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Main_shells_change(shells):
    var shells_string = shells_format % shells
    
    text = shells_string
