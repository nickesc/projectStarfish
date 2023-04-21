extends Obstacle

signal collect_shell()



# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Area2D_body_entered(body):
    emit_signal("collect_shell")
    print(body)
    controller._clear_obstacle(self)
