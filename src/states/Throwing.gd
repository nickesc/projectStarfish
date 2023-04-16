extends StarState

var tapped = false
var released = false
# Virtual function. Receives events from the `_unhandled_input()` callback
func handle_input(event: InputEvent) -> void:
    
    var mouse_pos1 = Vector2.ZERO
    var mouse_pos2 = Vector2.ZERO
    var theta1
    var theta2

    if event.is_action_pressed("throw_input") and not tapped:
        tapped = true
        released = false
        mouse_pos1 = get_viewport().get_mouse_position()/2 - owner.position + (star.position - star.initial_position) + Vector2(0,20)
        owner.get_node("ThrowingVectorLine").clear_points()
        owner.get_node("ThrowingVectorLine").add_point(mouse_pos1,0)
        theta1 = rad2deg(atan2(mouse_pos1.y, mouse_pos1.x))
        print("mouse1: ",mouse_pos1,theta1)

    if event.is_action_released("throw_input") and not released:
        released = true
        tapped = false
        mouse_pos2 = get_viewport().get_mouse_position()/2 - owner.position  + (star.position - star.initial_position) + Vector2(0,20)
        owner.get_node("ThrowingVectorLine").add_point(mouse_pos2,1)
        theta2 = rad2deg(atan2(mouse_pos2.y, mouse_pos2.x))
        print("mouse2: ",mouse_pos2,theta2)
        #var throw_vector = mouse_pos2 - mouse_pos1
        
        
        var first = owner.get_node("ThrowingVectorLine").points[0]
        var second = owner.get_node("ThrowingVectorLine").points[1]
        
        var throw_vector = first - second
        var power = throw_vector.length()/30
        var degrees = rad2deg(throw_vector.angle())*-1
        
        owner.get_node("ThrowingVectorLine").clear_points()
        star.throw(power,degrees)
        print ("power: ",power, " angle: ", degrees)
    
    
    pass

# Virtual function. Called by the state machine upon changing the active state
func enter(msg: Dictionary = {}) -> void:
    print("state: throwable")
    star.emit_signal("throwable")
    
    
# Virtual function. Corresponds to the `_process()` callback
func update(delta: float) -> void:
    pass

# Virtual function. Corresponds to the `_physics_process()` callback
func physics_update(delta: float) -> void:
    pass

# Virtual function. Called by the state machine before changing the active state
func exit() -> void:
    star.jumps-=1
    star.emit_signal("thrown", star.speed, star.angle)
