class_name Star
extends KinematicBody2D

signal reset()

signal gravity_change(gravity)
signal score_change(score)
signal max_position_change(new_max_position)
signal jumps_changed(jumps_left)
signal modifying_movement(direction)
signal stopped_modifying_movement(direction)

signal throwable()
signal thrown(speed, angle)

signal idle()
signal throwing()
signal flying()
signal flailing()
signal fallen()
signal idle_end()
signal throwing_end()
signal flying_end()
signal flailing_end()
signal fallen_end()

signal first_throw()
#signal need_more_obstacles(curr_position_x)

export (bool) var dev = false



export var max_jumps = 3
export var gravity = 7.3
onready var state_machine =  get_node("StarStateMachine")
export var flailing_speed = -35
export var y_minimum = 340
var first_throw = true
var time_up = false



var jumps
var score = 0
var max_position = Vector2.ZERO



export var right_flying_movement_modifier = 1.5
export var left_flying_movement_modifier = .3
export var right_flailing_movement_modifier = 100
export var left_flailing_movement_modifier = -100
export var down_movement_modifier = 1.5
export var velocity_increase_reward = .75
export var velocity_decrease_cost = 1.5
export var throw_input_power_division_factor = 35
export var pixel_to_meter_conversion_factor = 200

export var beach_x_offset = 250
export var beach_y_offset = 50
export var obstacle_spawn_x_interval = 3000

var initial_position
var initial_y_minimum
var initial_gravity
var initial_max_jumps
var initial_flailing_speed
var last_thrown_inputs = [false, false, false]
var last_position = position
var last_collision
var last_velocity = Vector2.ZERO
var next_velocity = Vector2.ZERO
var obstacle_spawn_x_interval_progress

var screen_size


export var throwing_vector_line_path: NodePath
var throwing_vector_line: Line2D
export var sprite_path: NodePath
var sprite: AnimatedSprite

export var camera_path: NodePath
var camera: Camera2D


var Vx = 0
var Vy = 0
var angle
var speed



var Vx_reference = Vx

var start_time


var thrown = false
var flailing = false
var sliding = false
var still = false
var still_and_sliding = 0



func update_jumps(new_jumps):
    jumps = new_jumps
    if dev:
        jumps = 1000
    emit_signal("jumps_changed", jumps)

func reset_jumps():
    update_jumps(initial_max_jumps)
    

func reset_throw():
    position = initial_position
    obstacle_spawn_x_interval_progress = 0
    last_position = position
    y_minimum = initial_y_minimum + beach_y_offset
    first_throw = true
    #print("help me :P")
    change_state("Idle")

func reset_velocity():
    flailing_speed = initial_flailing_speed
    last_collision = null
    last_velocity = Vector2.ZERO
    next_velocity = Vector2.ZERO

func reset():
    time_up = false
    score = 0
    update_max_position(Vector2.ZERO)
    reset_score_timer()
    reset_jumps()
    #jumps = 1000
    emit_signal("reset")
    reset_throw()
    update_gravity(initial_gravity)


func start_score_timer():
    $ScoreTimer.start()

func reset_score_timer():
    $ScoreTimer.stop()
    


func change_state(target_state: String, msg: Dictionary = {}):
    state_machine.change_state(target_state, msg)

func update_gravity(new_gravity):
    gravity = new_gravity
    Physics2DServer.area_set_param(get_viewport().find_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, gravity*10)
    emit_signal("gravity_change",gravity)

func _on_ScoreTimer_timeout():
    score += .1
    emit_signal("score_change",score)

# the regular physics loop for the star; asks for velocity components, a delta, and whether the star is flailing
func normal_physics(velocity_x, velocity_y, modifier, delta):
    
    
    # set the last velocity from whatever the vector given was, before we start changing it
    last_velocity = Vector2(velocity_x,velocity_y)
    
    # if the ball is moving in the downwards direction
    if velocity_y!=0:
        
        if not is_on_ceiling() and not is_on_floor() and not is_on_wall():
        
            # apply gravity to the current velocity calculations and to the permement velocity
            
            
            
            velocity_y += gravity * delta * 60
            
            next_velocity.y = velocity_y
    
    # create a vector from the velocity components
    var velocity = Vector2(velocity_x,velocity_y) + modifier
    
    # check the movement modifiers from keyboard, depending on flailing or not
    #if flailing:
    #    velocity = check_flailing(velocity)
    #else:
    #    velocity = check_movement(velocity)
        
    
    # move the star and get collision info
    var collision_info = move_and_collide(velocity * delta)
    last_collision = collision_info
    
    # if there is collision info, adjust the velocity for it
    if collision_info:
        velocity = velocity.bounce(collision_info.normal)
    
    # cleanup movement at the end
    movement_cleanup(velocity)

    return velocity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func throw(power, degrees):
    start_time = Time.get_ticks_usec()
    
    speed = power * 100
    angle = deg2rad(degrees * -1)
    
    Vx = cos(angle) * speed
    Vy = sin(angle) * speed
    
    next_velocity = Vector2(Vx, Vy)
    
    Vx_reference = Vx
    update_jumps(jumps-1)
    #emit_signal("jumped",jumps)
    
    change_state("Flying")

func set_initial_values():
        
    initial_y_minimum = y_minimum
    initial_gravity = gravity
    initial_max_jumps = max_jumps
    initial_flailing_speed = flailing_speed
    initial_position = position

# Called when the node enters the scene tree for the first time.
func _ready():
    set_initial_values()
    screen_size = get_viewport_rect().size
    throwing_vector_line = get_node(throwing_vector_line_path)
    camera = get_node(camera_path)
    sprite = get_node(sprite_path)
    Physics2DServer.area_set_param(get_viewport().find_world_2d().get_space(), Physics2DServer.AREA_PARAM_GRAVITY, gravity*10)
    y_minimum = initial_y_minimum + beach_y_offset
    update_jumps(max_jumps)
    

    if true:

        pass


func movement_cleanup(velocity):
    
    #position_vector = Vector2(position.x, position.y)
    $AnimatedSprite.rotation = velocity.angle()
    
    if y_minimum>=initial_y_minimum:
        
        if position.x > initial_position.x + beach_x_offset and position.y < initial_y_minimum:
            y_minimum = initial_y_minimum
        #elif position.x > initial_position.x + beach_x_offset:
            #y_minimum = y_minimum - (position.x - (initial_position.x + beach_x_offset))
    
    if (position.y >= y_minimum):
         change_state("Fallen")
    elif velocity.x <= 0 or position.is_equal_approx(last_position) or time_up or (velocity.x != 0 and last_collision == null and velocity.y==0):
         change_state("Flailing")
        
    #var last_check = 0
    #if last_position.x:
        #last_check = last_position.x
        
    #obstacle_spawn_x_interval_progress += position.x - last_check.x
    #if obstacle_spawn_x_interval_progress>=obstacle_spawn_x_interval:
        #obstacle_spawn_x_interval_progress = 0
        #emit_signal("need_more_obstacles", position.x)
    
    last_position = position
    
    
    
    
    
    update_max_position(get_max_position_vector(last_position))
    

func update_max_position(new_max_position):
    
    max_position = new_max_position
    emit_signal("max_position_change", max_position)
    
    #next_velocity = velocity


func get_max_position_vector(test_vector) -> Vector2:
    var new_max_position = max_position
    test_vector = test_vector - initial_position
    
    if test_vector.x > max_position.x:
        new_max_position.x = test_vector.x
        
        
    if test_vector.y < max_position.y:
        new_max_position.y = test_vector.y
        
    if test_vector.x < 0 and max_position.x <= 0:
        new_max_position.x = test_vector.x
        
    return new_max_position

func _physics_process(delta):
    #print(next_velocity)
    pass



func _on_TimeLimitTimer_timeout():
    time_up = true # Replace with function body.


#func check_movement(velocity):
#
#    var thrown_inputs = [Input.is_action_pressed("starfish_right"), Input.is_action_pressed("starfish_left"), Input.is_action_pressed("starfish_down")]
#
#    if velocity.x != 0:
#        if thrown_inputs[0]:
#            velocity.x *= right_thrown_movement_modifier
#            if thrown_inputs[0] != last_thrown_inputs[0]:
#                Vx = (right_thrown_movement_modifier*.75) * velocity.x
#        if thrown_inputs[1]:
#            velocity.x *= left_thrown_movement_modifier
#            if thrown_inputs[1] != last_thrown_inputs[1]:
#                Vx = (left_thrown_movement_modifier*1.5) * velocity.x
#
#    if velocity.y !=0:
#        if thrown_inputs[2]:
#            if velocity.y > 0:
#                velocity.y *= down_movement_modifier
#            else:
#                velocity.y /=down_movement_modifier
#
#    last_thrown_inputs = thrown_inputs
#    return velocity
#
#func check_flailing(velocity):
#
#    var flailing_inputs = [Input.is_action_pressed("starfish_right"), Input.is_action_pressed("starfish_left"), Input.is_action_pressed("starfish_down")]
#
#    if velocity.x != 0:
#        if flailing_inputs[0]:
#            velocity.x += 100
#        if flailing_inputs[1]:
#            velocity.x -= 100
#
#    if velocity.y !=0:
#        if flailing_inputs[2]:
#            velocity.y *= down_movement_modifier
#
#    return velocity
