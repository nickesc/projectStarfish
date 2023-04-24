extends StarState

#var timer_up = false

# Virtual function. Receives events from the `_unhandled_input()` callback
func handle_input(event: InputEvent) -> void:
    pass

# Virtual function. Called by the state machine upon changing the active state
func enter(msg: Dictionary = {}) -> void:
    print("state: fallen")
    star.emit_signal("fallen")
    star.reset_score_timer()
    star.splash()
    ##change_to_throwing = true



# func _on_reset_timer_timeout():
#     timer_up = true

# var delaying = false
# var start_delay_time

# Virtual function. Corresponds to the `_process()` callback
func update(delta: float) -> void:

    # if delaying:
    #     if Time.get_ticks_msec() < start_delay_time + 1000:
    #         pass
    #     else:
    #         delaying = false
    #         start_delay_time = null
    #         star.reset()


    if star.jumps>0 and not star.time_up:
        machine.change_state("Throwing")


    #if star.time_up or star.jumps <= 0 and not delaying:
    if star.time_up or star.jumps <= 0:
        star.reset()
        #star.emit_signal("stop_time_limit_timer")
        #yield(get_tree().create_timer(1.0), "timeout")
        #start_delay_time = Time.get_ticks_msec()
        #delaying = true

        #while Time.get_ticks_msec() < start_delay_time + 1000:
        #star.reset()
        #var timer = Timer.new()
        #timer.connect("timeout",self,"_on_reset_timer_timeout")
        #add_child(timer) #to process
        #timer.wait_time = 1
        #timer.one_shot = true
        #timer.start()



# Virtual function. Corresponds to the `_physics_process()` callback
func physics_update(delta: float) -> void:
    pass

# Virtual function. Called by the state machine before changing the active state
func exit() -> void:
    star.emit_signal("fallen_end")
