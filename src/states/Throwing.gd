extends StarState

var throwing_vector_line

var tapped = false
var released = false
# Virtual function. Receives events from the `_unhandled_input()` callback
func handle_input(event: InputEvent) -> void:
    
    var mouse_pos1 = Vector2.ZERO
    var mouse_pos2 = Vector2.ZERO

    if event.is_action_pressed("throw_input") and not tapped:
        tapped = true
        released = false
        mouse_pos1 = star.throwing_vector_line.get_local_mouse_position()
        throwing_vector_line.clear_points()
        
        mouse_pos1.x = clamp(mouse_pos1.x, 0, star.screen_size.x)
        mouse_pos1.y = clamp(mouse_pos1.y, 0, star.screen_size.y)
        
        throwing_vector_line.add_point(mouse_pos1,0)
        print("mouse1: ",mouse_pos1,rad2deg(atan2(mouse_pos1.y, mouse_pos1.x)))

    if event.is_action_released("throw_input") and not released:
        released = true
        tapped = false
        mouse_pos2 = star.throwing_vector_line.get_local_mouse_position()
        
        mouse_pos2.x = clamp(mouse_pos2.x, 0, star.screen_size.x)
        mouse_pos2.y = clamp(mouse_pos2.y, 0, star.screen_size.y)
        
        throwing_vector_line.add_point(mouse_pos2,1)
        print("mouse2: ",mouse_pos2,rad2deg(atan2(mouse_pos2.y, mouse_pos2.x)))
        #var throw_vector = mouse_pos2 - mouse_pos1
        
        
        var first = throwing_vector_line.points[0]
        var second = throwing_vector_line.points[1]
        
        var throw_vector = first - second
        var power = throw_vector.length() / star.throw_input_power_division_factor
        var degrees = rad2deg(throw_vector.angle())*-1
        
        throwing_vector_line.clear_points()
        star.throw(power,degrees)
        print ("power: ",power, " angle: ", degrees)

# Virtual function. Called by the state machine upon changing the active state
func enter(msg: Dictionary = {}) -> void:
    throwing_vector_line = star.throwing_vector_line
    print("state: throwable")
    
    
    star.emit_signal("throwing")
    star.emit_signal("throwable")
    
    
# Virtual function. Corresponds to the `_process()` callback
func update(delta: float) -> void:
    
    if star.time_up:
        star.throw(0,0)
    
    pass

# Virtual function. Corresponds to the `_physics_process()` callback
func physics_update(delta: float) -> void:
    pass

# Virtual function. Called by the state machine before changing the active state
func exit() -> void:
    if star.first_throw == true:
        star.emit_signal("first_throw")
        star.first_throw = false
    star.jumps-=1
    star.start_score_timer()
    star.emit_signal("throwing_end")
    #star.emit_signal("thrown", star.speed, star.angle)
