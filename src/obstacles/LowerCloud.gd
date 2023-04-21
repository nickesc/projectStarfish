extends Obstacle

#export(String, "large_curly", "large_long", "large_puffy", "medium_2_hump", "medium_even", "medium_jumping", "small_giant_dwarf", "small_pill", "small_v") var shape = null
var shapes =  ["large_long", "large_puffy", "medium_curly", "medium_2_hump", "medium_even", "medium_jumping", "medium_v", "small_giant_dwarf", "small_pill"]
var shapes_reference = shapes
var curr_shape
#var spawn_distance_interval = 2000
#var initial_position = Vector2.ZERO

var start_translucent = false
var start_opaque = false
var curr_opacity: float = 1




func set_speed(new_speed):
    speed = new_speed

func pick_shape():
    curr_shape = controller.random_from(shapes)
    #if curr_shape[0]=="s":
    #    $Area2D/CollisionShape2D.set_scale(Vector2(0.6,0.4))
    #elif curr_shape[0]=="m":
    #    $Area2D/CollisionShape2D.set_scale(Vector2(0.9,0.7))
    #elif curr_shape[0]=="l":
    #    $Area2D/CollisionShape2D.set_scale(Vector2(1.4,0.9))
    sprite.play(curr_shape)
    return curr_shape


func set_opacity(opacity: float):
    curr_opacity = opacity
    sprite.modulate.a = opacity

# Called when the node enters the scene tree for the first time.
func enter():
    pick_shape()

func process_update(lower):
    if start_translucent:
        if curr_opacity > .5:
            set_opacity(curr_opacity-.1)
        elif curr_opacity == .5:
            start_translucent = false 
    if start_opaque:
        if curr_opacity < 1:
            set_opacity(curr_opacity+.1)
        elif curr_opacity == 1:
            start_opaque = false
    
    #if position.x <= initial_position.x - spawn_distance_interval*2:
        #queue_free()

func translucent():
    sprite.modulate.a = .3

func opaque():
    sprite.modulate.a = 1


func _on_Area2D_body_entered(body):
    if not start_translucent:
        start_translucent = true
    #translucent()


func _on_Area2D_body_exited(body):
    if $Area2D.get_overlapping_bodies().size() == 0:
        start_translucent = false
        start_opaque = true
        
