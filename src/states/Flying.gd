extends StarState

#var last_flying_inputs = [false,false,false]
#var last_flying_inputs = {"right":false, "left":false, "down":false, "up":false}
#var last_flying_release = {"right":false, "left":false, "down":false, "up":false}
var vector_modifier = Vector2.ZERO

var active_movement_modifiers = {"right":false, "left": false, "down": false, "up": false}

# Virtual function. Receives events from the `_unhandled_input()` callback
func handle_input(event: InputEvent) -> void:
    
    var curr_flying_inputs = {
                            "right_press":event.is_action_pressed("starfish_right"), 
                            "left_press":event.is_action_pressed("starfish_left"), 
                            "down_press":event.is_action_pressed("starfish_down"), 
                            "up_press":event.is_action_pressed("starfish_up"), 
                            "right_release":event.is_action_released("starfish_right"), 
                            "left_release":event.is_action_released("starfish_left"), 
                            "down_release":event.is_action_released("starfish_down"), 
                            "up_release":event.is_action_released("starfish_up")
                            }
    
    if curr_flying_inputs["right_press"] and not event.is_echo():
        active_movement_modifiers["right"] = true
        
    if curr_flying_inputs["left_press"] and not event.is_echo():
        active_movement_modifiers["left"] = true
        
    if curr_flying_inputs["down_press"] and not event.is_echo():
        active_movement_modifiers["down"] = true
    
    if curr_flying_inputs["up_press"] and not event.is_echo():
        active_movement_modifiers["up"] = true
        
    if curr_flying_inputs["right_release"] and not event.is_echo():
        active_movement_modifiers["right"] = false
        # if right is released, the permenant x speed is multiplied by 75% of the right movement modifier (if velocity_increase_reward = .75)
        star.next_velocity.x = (star.right_flying_movement_modifier * star.velocity_increase_reward) * star.next_velocity.x
        
    if curr_flying_inputs["left_release"] and not event.is_echo():
        active_movement_modifiers["left"] = false
        # if left is released, the permenant x speed is multiplied by 150% of the left movement modifier (if velocity_decrease_cost = 1.5)
        star.next_velocity.x = (star.left_flying_movement_modifier * star.velocity_decrease_cost) * star.next_velocity.x
        
    if curr_flying_inputs["down_release"] and not event.is_echo():
        active_movement_modifiers["down"] = false
    
    if curr_flying_inputs["up_release"] and not event.is_echo():
        active_movement_modifiers["up"] = false
    
    
#    
#        if curr_flying_inputs["right_release"]:
#            #release = true
#            vector_modifier.x = 0
#            star.next_velocity.x = (star.right_flying_movement_modifier * star.velocity_increase_reward) * star.next_velocity.x
#        
#        if curr_flying_inputs["left_release"]:
#            #release = true
#            vector_modifier.x = 0
#            star.next_velocity.x = (star.left_flying_movement_modifier * star.velocity_decrease_cost) * star.next_velocity.x
        

    
    
            
            
    


# Virtual function. Called by the state machine upon changing the active state
func enter(msg: Dictionary = {}) -> void:
    print("state: flying")
    star.emit_signal("thrown")
    
# Virtual function. Corresponds to the `_process()` callback
func update(delta: float) -> void:
    pass

# Virtual function. Corresponds to the `_physics_process()` callback
func physics_update(delta: float) -> void:
    
    var initial_velocity = Vector2(star.next_velocity.x, star.next_velocity.y)
    var modified_velocity = initial_velocity
    
    # if the star is moving in the x direction
    if initial_velocity.x != 0:
        # if right is pressed, multiply the modified velocity x component by the right movement modifier
        if active_movement_modifiers["right"]:
            modified_velocity.x *= star.right_flying_movement_modifier
        # if left is pressed, multiply the modified velocity x component by the left movement modifier
        if active_movement_modifiers["left"]:
            modified_velocity.x *= star.left_flying_movement_modifier
    
    # if the star is moving in the y direction
    if initial_velocity.y !=0:
        # if down is pressed
        if active_movement_modifiers["down"]:
            # if the star is moving down, multiply the modified velocity y component by the down movement modifier
            if modified_velocity.y > 0:
                modified_velocity.y *= star.down_movement_modifier
            # if the star is moving up, multiply the modified velocity y component by the down movement modifier
            else:
                modified_velocity.y /= star.down_movement_modifier
#        if curr_flying_inputs["down_release"]:
#            vector_modifier.y = 0

    # set the vector modifier
    vector_modifier = modified_velocity - initial_velocity
    
    #var modified_velocity = star.next_velocity + vector_modifier
    
    var last_velocity = star.normal_physics(star.next_velocity.x, star.next_velocity.y, vector_modifier, delta)
    
    #print(star.next_velocity)
    

# Virtual function. Called by the state machine before changing the active state
func exit() -> void:
    pass
