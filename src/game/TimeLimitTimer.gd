extends Timer

signal time_change(time)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _process(delta):
    if not is_stopped():
        emit_signal("time_change", get_time_left())

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func _on_Star_first_throw():
    start()
