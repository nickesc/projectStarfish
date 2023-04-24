tool
extends CanvasLayer

var begun = false

export var hud_path: NodePath
var  hud: CanvasLayer

export var star_path: NodePath
var star: Star

export var music_controller_path: NodePath
var music_controller: Node

func _input(event):
    if not Engine.is_editor_hint():
        if not begun:
            if event.is_action_released("throw_input"):
                begun = true
                $Logo/TapSlashClick.set_visible(false)
                $Logo/PlayButtons.set_visible(true)
                #$MenuMusic.play()
                music_controller.play_menu_music()
                music_controller.start_wave_crashing()
            

# Called when the node enters the scene tree for the first time.
func _ready():
    
    if not Engine.is_editor_hint():
        scale *= 2
        hud = get_node(hud_path)
        star = get_node(star_path)
        music_controller = get_node(music_controller_path)
        hud.set_visible(false)
        star.set_visible(false)
        $Logo/PlayButtons.set_visible(false)
    
    


func _on_Play_button_up():
    #music_controller.stop_menu_music()
    set_visible(false)
    hud.set_visible(true)
    star.set_visible(true)
    #music_controller.play_game_music()
    
