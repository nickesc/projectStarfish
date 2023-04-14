extends KinematicBody2D

signal throwable()
signal thrown(speed, angle)
signal flailing()
signal gravity_change(gravity)

export var gravity = 9.8

var screen_size

var Vx = 0
var Vy = 0
var angle
var speed

var start_time


var thrown = false
var flailing = false


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
    
    #print (Vx,Vy)
    
    thrown=true
    emit_signal("thrown", speed, angle)

# Called when the node enters the scene tree for the first time.
func _ready():
    screen_size = get_viewport_rect().size
    get_ready()
    
    
func check_movement(velocity):
    if velocity.x != 0:
        if Input.is_action_pressed("starfish_right"):
            velocity.x *= 1.5
        if Input.is_action_pressed("starfish_left"):
            velocity.x /= 1.5
                
    if velocity.y !=0:
        if Input.is_action_pressed("starfish_down"):
            velocity.y *= 1.5
    
    return velocity

func check_flailing(velocity):
    if velocity.x != 0:
        if Input.is_action_pressed("starfish_right"):
            velocity.x += 10
        if Input.is_action_pressed("starfish_left"):
            velocity.x -= 10
                
    if velocity.y !=0:
        if Input.is_action_pressed("starfish_down"):
            velocity.y *= 1.5
    
    return velocity
    

func _physics_process(delta):
    #var elapsed_time = Time.get_ticks_usec() - start_time
    
    var velocity = Vector2(Vx,Vy)
    
    if thrown:
        if Vy!=0:
            Vy += gravity
        
        if not flailing:
            velocity = check_movement(velocity)
        else:
            velocity = check_flailing(velocity)
        
        var collision_info = move_and_collide(velocity * delta)
        if collision_info:
            velocity = velocity.bounce(collision_info.normal)
            
            if velocity.x < 0:
                Vx=0
                flailing = true
                emit_signal("flailing")
            else:
                Vx = velocity.x
                Vy = velocity.y
            
        
    #position.x = clamp(position.x, 0, screen_size.x)
    #position.y = clamp(position.y, 0, screen_size.y)
        
        if (position.y >= 400):
            Vy=0
            Vx=0
            thrown = false
            flailing = false
            emit_signal("throwable")
        
