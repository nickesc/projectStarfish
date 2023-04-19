extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var right_button: TouchScreenButton
var left_button: TouchScreenButton

var _normal: Texture
var _initial_normal: Texture
var _pressed: Texture


func translucent(button: TouchScreenButton):
    button.modulate.a = .3

func opaque(button: TouchScreenButton):
    button.modulate.a = 1

func press(button: TouchScreenButton):
    button.set_texture(_pressed)
    
func release(button: TouchScreenButton):
    button.set_texture(_initial_normal)

# Called when the node enters the scene tree for the first time.
func _ready():    
    right_button = get_node("RightMovementButton")
    left_button = get_node("LeftMovementButton")
    
    _normal = right_button.get_texture()
    _initial_normal = right_button.get_texture()
    _pressed = right_button.get_texture_pressed()
    
    translucent(right_button)
    translucent(left_button)

func _on_Star_flying():
    opaque(right_button)
    opaque(left_button)

func _on_Star_flying_end():
    translucent(right_button)
    translucent(left_button)

func _on_Star_modifying_movement(direction):
    if direction == "right":
        press(right_button)
    if direction == "left":
        press(left_button)


func _on_Star_stopped_modifying_movement(direction):
    if direction == "right":
        release(right_button)
    if direction == "left":
        release(left_button)
