extends PanelContainer

signal get_ready()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func hide_and_ready():
    set_visible(false)
    emit_signal("get_ready")

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_StartButton_button_up():
    hide_and_ready()
