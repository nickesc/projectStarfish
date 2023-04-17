extends KinematicBody2D


export(String, "blue", "red", "yellow", "green") var color = null
var colors =  ["blue", "red", "yellow", "green"]
var colors_reference = colors
var color_picker: RandomNumberGenerator
var curr_animation

var moving = false

func pick_color():
    return colors[color_picker.randi() % colors.size()]
    
func play(animation):
    $AnimatedSprite.play(animation)
    $AnimatedSprite.set_frame(color_picker.randi() % 8)
    
func stop():
    $AnimatedSprite.stop()
    
func pick_animation(animation):
    if animation == "flying":    
        curr_animation = color +"_flying"
    else:
        curr_animation = color +"_flying"
    
    play(curr_animation)


func _ready():
    stop()
    color_picker = RandomNumberGenerator.new()
    color_picker.randomize()
    
    if color == null:
        color = pick_color()
    
    pick_animation("flying")
        
func _physics_process(delta):
    if moving:
        position.x += 1
