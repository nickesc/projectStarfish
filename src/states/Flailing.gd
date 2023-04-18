extends StarState
var vector_modifier = Vector2.ZERO

# Virtual function. Receives events from the `_unhandled_input()` callback
func handle_input(event: InputEvent) -> void:
    pass
    #var release = false
    
    

# Virtual function. Called by the state machine upon changing the active state
func enter(msg: Dictionary = {}) -> void:
    print("state: flailing")
    star.update_gravity(13)
    star.emit_signal("flailing")
    
    if star.next_velocity.y == 0 or star.next_velocity.is_equal_approx(Vector2.ZERO):
        star.next_velocity.y = 1
    #star.next_velocity.x = -35
    
# Virtual function. Corresponds to the `_process()` callback
func update(delta: float) -> void:
    # if is on ground/platform -> set animation to crawling
    pass

# Virtual function. Corresponds to the `_physics_process()` callback
func physics_update(delta: float) -> void:
    
    star.next_velocity.x = -35
    if star.next_velocity.y < -100:
        star.next_velocity.y = -100
    
    #var modified_velocity = star.next_velocity + vector_modifier
    var modified_velocity = star.next_velocity
    
    star.next_velocity = star.normal_physics(star.next_velocity.x, star.next_velocity.y, Vector2.ZERO, delta)
#    var velocity = Vector2(star.Vx,star.Vy)
#
#    if star.Vy!=0:
#        star.Vy += star.gravity
#
#    velocity = star.check_flailing(velocity)
#
#    var collision_info = star.move_and_collide(velocity * delta)        
#    if collision_info:
#        velocity = velocity.bounce(collision_info.normal)
#
#        if velocity.x <= 0:
#
#            emit_signal("flailing")
#        else:
#            Vx = velocity.x
#            Vy = velocity.y
#
#    star.movement_cleanup()

# Virtual function. Called by the state machine before changing the active state
func exit() -> void:
    star.update_gravity(star.initial_gravity)
    star.emit_signal("flailing_end")
