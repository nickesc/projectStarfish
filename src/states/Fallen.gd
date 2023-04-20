extends StarState


# Virtual function. Receives events from the `_unhandled_input()` callback
func handle_input(event: InputEvent) -> void:
    pass

# Virtual function. Called by the state machine upon changing the active state
func enter(msg: Dictionary = {}) -> void:
    print("state: fallen")
    star.emit_signal("fallen")
    star.reset_score_timer()
    star.position.y = star.y_minimum
    star.Vy=0
    star.Vx=0
    if star.jumps>0 and not star.time_up:
        machine.change_state("Throwing")
    
    
    
# Virtual function. Corresponds to the `_process()` callback
func update(delta: float) -> void:
    if star.time_up or star.jumps <= 0:
        star.reset()

# Virtual function. Corresponds to the `_physics_process()` callback
func physics_update(delta: float) -> void:
    pass

# Virtual function. Called by the state machine before changing the active state
func exit() -> void:
    star.emit_signal("fallen_end")
