extends Node

signal throw(speed, angle)
signal angle_change(angle)
signal power_change(power)
signal score_change(score)


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var time_limit = 60
var score = 0

var time_limit_timer: Timer

export var power = 1
export var angle = 1
export (Color) var clear_color = Color(0.3,0.3,0.3)
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
    


# Called when the node enters the scene tree for the first time.
func _ready():
    
    VisualServer.set_default_clear_color(clear_color)
    time_limit_timer = $TimeLimitTimer
    time_limit_timer.wait_time = time_limit
    
    pass # Replace with function body.

func _process(delta):
    pass
#    if throwable:
#
#
#
#        if is_choosing_angle:
#
#
#
#            if check_throw_selection():
#                choose_angle()
#                var mouse_pos = get_viewport().get_mouse_position()
#                var theta = rad2deg(atan2(mouse_pos.y, mouse_pos.x))
#                #print(mouse_pos, theta)
#                #print(atan())
#        if is_choosing_power:
#            if check_throw_selection():
#                choose_power()
        
        
            
            #thrown = true
