extends CanvasLayer

onready var camera = get_tree().current_scene.get_node("Camera2D")


func send_to_back():
    set_layer(-1)

func send_to_front():
    set_layer(2)

func _on_Star_fallen():
    send_to_front()


func _on_Star_flying():
    send_to_back()



func _on_Star_reset():
    send_to_back()
