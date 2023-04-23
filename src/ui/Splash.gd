tool
extends CanvasLayer

export var hud_path: NodePath
var  hud: CanvasLayer

export var star_path: NodePath
var star: Star

func _input(event):
    if not Engine.is_editor_hint():
        if event.is_action_pressed("throw_input"):
            $TextureRect/TapSlashClick.set_visible(false)
            $TextureRect/PlayButtons.set_visible(true)
            

# Called when the node enters the scene tree for the first time.
func _ready():
    
    if not Engine.is_editor_hint():
        scale *= 2
        hud = get_node(hud_path)
        star = get_node(star_path)
        hud.set_visible(false)
        star.set_visible(false)
        $TextureRect/PlayButtons.set_visible(false)
    
    


func _on_Play_button_up():
    set_visible(false)
    hud.set_visible(true)
    star.set_visible(true)
    
