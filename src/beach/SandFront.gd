extends CanvasLayer

onready var camera = get_tree().current_scene.get_node("Star/Camera2D")



func _on_Star_fallen():
    set_layer(2)
    #pass # Replace with function body.


func _on_Star_thrown(speed, angle):
    set_layer(-1)
