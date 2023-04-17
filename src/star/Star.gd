class_name Star
extends KinematicBody2D

signal throwable()
signal thrown(speed, angle)
signal flailing()
signal gravity_change(gravity)
signal score_change(score)

export (bool) var dev = false

export var max_jumps = 3
export var gravity = 9.8
onready var state_machine =  get_node("StarStateMachine")
export var flailing_speed = -35


export var right_flying_movement_modifier = 1.25
export var left_flying_movement_modifier = .5
export var right_flailing_movement_modifier = 100
export var left_flailing_movement_modifier = -100
export var down_movement_modifier = 1.5
export var velocity_increase_reward = .75
export var velocity_decrease_cost = 1.5
export var throw_input_power_division_factor = 50

var initial_position
var last_thrown_inputs = [false, false, false]
var last_position = position
var last_collision
var last_velocity = Vector2.ZERO
var next_velocity = Vector2.ZERO

var screen_size

var Vx = 0
var Vy = 0
var angle
var speed
var jumps
var score = 0




var Vx_reference = Vx

var start_time


var thrown = false
var flailing = false
var sliding = false
var still = false
var still_and_sliding = 0

func start_score_timer():
    $ScoreTimer.start()

func reset_score_timer():
    $ScoreTimer.stop()
    


func change_state(target_state: String, msg: Dictionary = {}):
    state_machine.change_state(target_state, msg)

func update_gravity(new_gravity):
    gravity = new_gravity
    emit_signal("gravity_change",gravity)

func _on_ScoreTimer_timeout():
    score += .1
    emit_signal("score_change",score)

# the regular physics loop for the star; asks for velocity components, a delta, and whether the star is flailing
func normal_physics(velocity_x, velocity_y, modifier, delta, flailing=false):
    
    # set the last velocity from whatever the vector given was, before we start changing it
    last_velocity = Vector2(velocity_x,velocity_y)
    
    # if the ball is moving in the downwards direction
    if velocity_y!=0:
        # apply gravity to the current velocity calculations and to the permement velocity
        velocity_y += gravity
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
    
    change_state("Flying")

# Called when the node enters the scene tree for the first time.
func _ready():
    screen_size = get_viewport_rect().size
    initial_position = position
    jumps = max_jumps
    if dev:
        jumps = 1000

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
#
func movement_cleanup(velocity):
    
    #position_vector = Vector2(position.x, position.y)
    $AnimatedSprite.rotation = velocity.angle()
    
    if (position.y >= 400):
         change_state("Fallen")
    elif velocity.x <= 0 or position.is_equal_approx(last_position):
         change_state("Flailing")
    last_position = position
    #next_velocity = velocity
    

func _physics_process(delta):
    #print(next_velocity)
    pass
#    #var elapsed_time = Time.get_ticks_usec() - start_time
#
#    var velocity = Vector2(Vx,Vy)
#
#
#    if thrown:
#
#        #if int(round(position.x)) == int(round(last_position.x)) and int(round(position.y)) == int(round(last_position.y)):
#        #    still = true
#        #else:
#        #    still = false
#
#        #if still and sliding:
#        #    still_and_sliding+=1
#        #else:
#        #    still_and_sliding = 0
#            #print("Still and sliding")
#        #if still_and_sliding>100:
#        #    Vx = -20
#        #    Vy = -1
#        #    print("Still and sliding")
#
#        if Vy!=0:
#            Vy += gravity
#
#        if not flailing:
#            velocity = check_movement(velocity)
#        else:
#            velocity = check_flailing(velocity)
#
#        var collision_info = move_and_collide(velocity * delta)
#        #var collision_test = move_and_collide(velocity * delta, true, true, true)
#
#        if collision_info:
#            velocity = velocity.bounce(collision_info.normal)
#
#            if velocity.x <= 0:
#                flailing = true
#                emit_signal("flailing")
#            else:
#                Vx = velocity.x
#                Vy = velocity.y
#
#        last_collision = collision_info
#
#
#
#        #else:
#
#            #collision_info = move_and_collide(velocity * delta)
#            #sliding = false
#            #if Vx <= 0:
#                #Vx = 20
#
#        #if flailing:
#            #Vx = -35
#
#
#    #position.x = clamp(position.x, 0, screen_size.x)
#    #position.y = clamp(position.y, 0, screen_size.y)
#
#        if (position.y >= 400):
#            position.y = 400
#            Vy=0
#            Vx=0
#            thrown = false
#            flailing = false
#            emit_signal("throwable")
#
#    last_position = position
    #print(velocity)
        



