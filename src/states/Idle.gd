extends StarState

# Virtual function. Receives events from the `_unhandled_input()` callback
func handle_input(event: InputEvent) -> void:
    pass

# Virtual function. Called by the state machine upon changing the active state
func enter(msg: Dictionary = {}) -> void:
    print("state: idle")
    star.emit_signal("idle")

# Virtual function. Corresponds to the `_process()` callback
func update(delta: float) -> void:
    star.change_state("Throwing")

# Virtual function. Corresponds to the `_physics_process()` callback
func physics_update(delta: float) -> void:
    pass

# Virtual function. Called by the state machine before changing the active state
func exit() -> void:
    star.emit_signal("idle_end")
