tool
class_name Obstacle
extends KinematicBody2D

signal past_origin(obstacle_instance)

var controller: ObstacleController

export (float, 0, 1.0, 0.05) var speed: float = 1.0
export var playing_by_default: bool = false
var playing: bool = playing_by_default

var sprite: AnimatedSprite
var animations: SpriteFrames
var default_animation: String
var curr_animation: String
var num_frames: int
var resume_on_frame: int

var obstacle: String
var moving: bool = false
    
func play(animation_name: String):
    if not playing:
        var resuming_animation = false
        
        # if the desired animation is the same as the current animation
        # set flag to resuming instead of getting a random frame
        if animation_name == curr_animation:
            resuming_animation = true
        else:
            resuming_animation = false
        
        if animations.get_animation_names().has(animation_name):
            playing = true
            curr_animation = animation_name
            sprite.play(curr_animation)
            num_frames = animations.get_frame_count(curr_animation)
            
            if num_frames>0:
                if resuming_animation:
                    sprite.set_frame(resume_on_frame)
                else:
                    sprite.set_frame(controller.random_int(num_frames))
    
func stop():
    if playing:
        playing = false
        resume_on_frame = sprite.frame
        sprite.stop()
    

    

func animation_setup() -> bool:
    if sprite:
        animations = sprite.get_sprite_frames()
        if animations:
            if animations.get_animation_names().size() > 0:
                default_animation = animations.get_animation_names()[0]
                play(default_animation)
        
        if not playing_by_default:
            stop()
        return true
    return false


func _ready():
    sprite = get_node_or_null("AnimatedSprite")
    animation_setup()
    
    if not Engine.editor_hint:
        enter()
            
func enter():
    pass

func _physics_process(delta):
    if not Engine.editor_hint:
        if moving:
            position.x -= 60 * speed * delta
            if position.x < -100:
                emit_signal("past_origin", self)
        physics_update(delta)
        

func physics_update(delta):
    pass

func _process(delta):
    
    if Engine.editor_hint:
        if configured:
            if playing_by_default:
                play(default_animation)
            else:
                stop()
            
    
    if not Engine.editor_hint:
        process_update(delta)

func process_update(delta):
    pass

var configured = false

func _get_configuration_warning() -> String:
    sprite = get_node_or_null("AnimatedSprite")
    if sprite:
        animation_setup()
        configured = true
        return ""
    else:
        configured = false
        return "Requires an AnimatedSprite child node to function"

func _update_configuration_warning() -> String:
    sprite = get_node_or_null("AnimatedSprite")
    if sprite:
        animation_setup()
        configured = true
        return ""
    else:
        configured = false
        return "Requires an AnimatedSprite to function"
