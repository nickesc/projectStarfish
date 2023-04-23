extends StarState

var vector_modifier = Vector2.ZERO

var active_movement_modifiers = {"right":false, "left": false, "down": false, "up": false}

# Virtual function. Receives events from the `_unhandled_input()` callback
func handle_input(event: InputEvent) -> void:

    if event.is_action_pressed("starfish_right") and not event.is_echo():
        star.apply_impulse(Vector2(0,1),Vector2(250,0))
        star.emit_signal("modifying_movement","right")
    if event.is_action_released("starfish_right") and not event.is_echo():
        star.emit_signal("stopped_modifying_movement","right")

    if event.is_action_pressed("starfish_left") and not event.is_echo():
        star.apply_impulse(Vector2(0,1),Vector2(-250,0))
        star.emit_signal("modifying_movement","left")
    if event.is_action_released("starfish_left") and not event.is_echo():
        star.emit_signal("stopped_modifying_movement","left")



# Virtual function. Called by the state machine upon changing the active state
func enter(msg: Dictionary = {}) -> void:
    print("state: flying")
    star.emit_signal("flying")

# Virtual function. Corresponds to the `_process()` callback
func update(delta: float) -> void:
    pass

# Virtual function. Corresponds to the `_physics_process()` callback
func physics_update(delta: float) -> void:

    star.normal_physics(delta)

# Virtual function. Called by the state machine before changing the active state
func exit() -> void:
    star.emit_signal("stopped_modifying_movement", "left")
    star.emit_signal("stopped_modifying_movement", "right")
    star.emit_signal("flying_end")
