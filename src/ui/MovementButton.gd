extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    modulate.a = .3
    #set_visible(false)
    


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Star_flying():
    #set_visible(true)
    modulate.a = 1


func _on_Star_flying_end():
    modulate.a = .3
    #set_visible(false)
