extends Node

export var star_path: NodePath
var star: Star

var music_mute = false
var effects_mute = false

#func _input(event):
#    if event.is_action_pressed("starfish_down"):
#        music_mute_toggle()
#    if event.is_action_released("starfish_down"):
#        music_mute_toggle()
#
#    if event.is_action_pressed("starfish_up"):
#        effects_mute_toggle()
#    if event.is_action_released("starfish_up"):
#        effects_mute_toggle()
func _ready():
    star = get_node(star_path)

func start_wave_crashing():
    play_wave_crashing()
    $WaveCrashing/WaveTimer.start()

func stop_wave_crashing():
    $WaveCrashing/WaveTimer.stop()

func play_wave_crashing():
    $WaveCrashing.play()

func play_menu_music():
    $MenuMusic.play()
    
func stop_menu_music():
    $MenuMusic.stop()

func play_game_music():
    $GameMusic.play()
    
func stop_game_music():
    $GameMusic.stop()

func _on_WaveTimer_timeout():
    if star.position.y > -1000:
        play_wave_crashing()


func effects_mute_toggle():
    var game_effects_bus = 2
    var ui_effects_bus = 3
    effects_mute = !effects_mute
    AudioServer.set_bus_mute(game_effects_bus,effects_mute)
    AudioServer.set_bus_mute(ui_effects_bus,effects_mute)

func music_mute_toggle():
    var music_bus = 1
    music_mute = !music_mute
    AudioServer.set_bus_mute(music_bus,music_mute)

func play_collect_shell_effect():
    $CollectEffect.play()
    
func play_buy_effect():
    $BuyEffect.play()

func play_no_buy_effect():
    $NoBuyEffect.play()

func play_click_down():
    $ClickDownEffect.play()

func play_click_up():
    $ClickUpEffect.play()

