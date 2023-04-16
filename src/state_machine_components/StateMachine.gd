class_name StateMachine
extends Node

signal state_change(state_name)

# Path to the initial active state.
export var initial_state := NodePath()
# The current active state
onready var state: State = get_node(initial_state)

func _ready() -> void:
    # wait for the root node to be ready
    yield(owner, "ready")
    
    # for each state in the machine
    for child in get_children():
        # assign the state machine to their machine variable
        child.machine = self
    # enter the initial state
    state.enter()

# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
    state.handle_input(event)
    
# call the state's update function
func _process(delta: float) -> void:
    state.update(delta)

# call the state's physics_update function
func _physics_process(delta: float) -> void:
    state.physics_update(delta)

# call current state's exit function, change the active state, call its enter function;
# takes state name as it appears in the scene tree and optionally takes a `msg` dictionary 
# to pass to the next state's enter function
func change_state(target_state: String, msg: Dictionary = {}) -> void:
    
    # if the desired state is not in the scene tree, ignore the transition call
    if not has_node(target_state):
        return
    
    # exit the current state
    state.exit()
    # set the new state
    state = get_node(target_state)
    # enter the next state
    state.enter(msg)
    # signal the state has changed
    emit_signal("state_change", state.name)
