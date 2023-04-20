extends Node

signal throw(speed, angle)
signal angle_change(angle)
signal power_change(power)
signal score_change(score)

signal reset_star()

signal time_limit_set(time_limit)


export var dev = false
export var pixel_to_meter_conversion_factor = 200
export (Color) var clear_color = Color(0.3,0.3,0.3)

export var time_limit: float = 10
var initial_time_limit
var score = 0

var time_limit_timer: Timer

export var power = 1
export var angle = 1

var last_angle = 0
var last_power = 0
var throwable = false

export var min_angle = 0
export var max_angle = 90
export var min_power = 1
export var max_power = 15

var is_choosing_angle = false
var is_choosing_power = false

var start_mouse_vector = false
var end_mouse_vector = false

var throw_selection_status = false
var last_throw_selection_status = false


func _on_AngleTimer_timeout():
    
    if angle > last_angle:
        if angle == max_angle:
            update_angle(angle - 1)
        else:        
            update_angle(angle + 1)
    elif angle < last_angle:
        if angle == min_angle:
            update_angle(angle + 1)
        else:        
            update_angle(angle - 1)

func _on_PowerTimer_timeout():
    if power > last_power:
        if power == max_power:
            update_power(power - 1)
        else:        
            update_power(power + 1)
    elif power < last_power:
        if power == min_power:
            update_power(power + 1)
        else:        
            update_power(power - 1)

func update_angle(new_angle):
    last_angle = angle
    angle = new_angle
    $Star/Camera2D/AngleLabel.text = str(angle) + "°"
    emit_signal("angle_change",angle)
    
func update_power(new_power):
    last_power = power
    power = new_power
    $Star/Camera2D/PowerLabel.text = str(power)
    emit_signal("power_change",power)

func choose_angle():
    $AngleTimer.stop()
    $PowerTimer.start()
    is_choosing_angle = false
    is_choosing_power = true
    
func choose_power():
    $PowerTimer.stop()
    is_choosing_power = false
    throwable = false
    $ScoreTimer.start()
    emit_signal("throw",power,angle)

func check_throw_selection():
    last_throw_selection_status = throw_selection_status
    throw_selection_status = Input.is_action_pressed("throw_selection")
    
    if throw_selection_status == true and throw_selection_status != last_throw_selection_status:
        return true
    else:
        return false

func reset_game():
    score = 0
    reset_time_limit_timer()

func reset_star():
    emit_signal("reset_star")
    

func set_time_limit(time):
    time_limit = time
    if dev:
        time_limit = 1000
    
    time_limit_timer.wait_time = time_limit
    emit_signal("time_limit_set", time_limit)

func set_initial_values():
    initial_time_limit = time_limit

# Called when the node enters the scene tree for the first time.
func _ready():
    set_initial_values()
    VisualServer.set_default_clear_color(clear_color)
    time_limit_timer = $TimeLimitTimer
    set_time_limit(time_limit)

func _process(delta):
    pass

func reset_time_limit_timer():
    time_limit_timer.stop()
    set_time_limit(initial_time_limit)

func _on_TimeLimitTimer_timeout():
    time_limit_timer.stop()
    
    print("time limit")


func _on_Star_reset():
    reset_game()
