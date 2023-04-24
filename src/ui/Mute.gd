extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _on_other_button_toggle(pressed):
    set_pressed_no_signal(pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
