extends PanelContainer

signal get_ready()

export var music_controller_path: NodePath
var music_controller: Node

func hide_and_ready():
    music_controller.stop_menu_music()
    music_controller.play_game_music()
    set_visible(false)
    emit_signal("get_ready")

func _ready():
    music_controller = get_node(music_controller_path)


func _on_StartButton_button_up():
    hide_and_ready()
