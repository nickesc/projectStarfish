tool
extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
    
    if not Engine.is_editor_hint():
        scale *= 2
