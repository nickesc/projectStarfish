extends KinematicBody2D

signal throwable()
signal thrown(speed, angle)
signal flailing()
signal gravity_change(gravity)

export var gravity = 9.8



export var right_thrown_movement_modifier = 1.25
export var left_thrown_movement_modifier = .5
export var right_flailing_movement_modifier = 100
export var left_flailing_movement_modifier = -100
export var down_movement_modifier = 1.5

var last_thrown_inputs = [false, false, false]
var last_position = position

## ndo the same thing as above but for flailing movement^^^^

var screen_size

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


func update_gravity(new_gravity):
    gravity = new_gravity
    emit_signal("gravity_change",gravity)


func get_ready():
    emit_signal("throwable")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func throw(power, degrees):
    start_time = Time.get_ticks_usec()
    
    speed = power * 100
    angle = deg2rad(degrees * -1)
    
    Vx = cos(angle) * speed
    Vy = sin(angle) * speed
    
    Vx_reference = Vx
    
    #print (Vx,Vy)
    
    thrown=true
    emit_signal("thrown", speed, angle)

# Called when the node enters the scene tree for the first time.
func _ready():
    screen_size = get_viewport_rect().size
    get_ready()
    
    
func check_movement(velocity):
    
    var thrown_inputs = [Input.is_action_pressed("starfish_right"), Input.is_action_pressed("starfish_left"), Input.is_action_pressed("starfish_down")]
    
    if velocity.x != 0:
        if thrown_inputs[0]:
            velocity.x *= right_thrown_movement_modifier
            if thrown_inputs[0] != last_thrown_inputs[0]:
                Vx = (right_thrown_movement_modifier*.75) * velocity.x
        if thrown_inputs[1]:
            velocity.x *= left_thrown_movement_modifier
            if thrown_inputs[1] != last_thrown_inputs[1]:
                Vx = (left_thrown_movement_modifier*1.5) * velocity.x
                
    if velocity.y !=0:
        if thrown_inputs[2]:
            if velocity.y > 0:
                velocity.y *= down_movement_modifier
            else:
                velocity.y /=down_movement_modifier
    
    last_thrown_inputs = thrown_inputs
    return velocity

func check_flailing(velocity):
    
    var flailing_inputs = [Input.is_action_pressed("starfish_right"), Input.is_action_pressed("starfish_left"), Input.is_action_pressed("starfish_down")]
    
    if velocity.x != 0:
        if flailing_inputs[0]:
            velocity.x += 100
        if flailing_inputs[1]:
            velocity.x -= 100
                
    if velocity.y !=0:
        if flailing_inputs[2]:
            velocity.y *= down_movement_modifier
    
    return velocity
    

func _physics_process(delta):
    #var elapsed_time = Time.get_ticks_usec() - start_time
    
    var velocity = Vector2(Vx,Vy)
    
    
    if thrown:
        
        if int(round(position.x)) == int(round(last_position.x)) and int(round(position.y)) == int(round(last_position.y)):
            still = true
        else:
            still = false
            
        if still and sliding:
            still_and_sliding+=1
        else:
            still_and_sliding = 0
            #print("Still and sliding")
        if still_and_sliding>100:
            Vx = -20
            Vy = -1
            print("Still and sliding")
        
        if Vy!=0:
            Vy += gravity
        
        if not flailing:
            velocity = check_movement(velocity)
        else:
            velocity = check_flailing(velocity)
            
        var collision_info = move_and_collide(velocity * delta)
        
        if collision_info:
            sliding = true
            velocity = velocity.bounce(collision_info.normal)
            
            if velocity.x <= 0:
                flailing = true
                emit_signal("flailing")
            else:
                Vx = velocity.x
                Vy = velocity.y
        else:
            sliding = false
            if Vx <= 0:
                Vx = 20
        
        if flailing:
            Vx = -35
            
        
    #position.x = clamp(position.x, 0, screen_size.x)
    #position.y = clamp(position.y, 0, screen_size.y)
        
        if (position.y >= 400):
            position.y = 400
            Vy=0
            Vx=0
            thrown = false
            flailing = false
            emit_signal("throwable")
    
    last_position = position
    #print(velocity)
        
