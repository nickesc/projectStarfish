extends AnimatedSprite


export(String, "large_curly", "large_long", "large_puffy", "medium_2_hump", "medium_even", "medium_jumping", "small_giant_dwarf", "small_pill", "small_v") var shape = null
var shapes =  ["large_curly", "large_long", "large_puffy", "medium_2_hump", "medium_even", "medium_jumping", "small_giant_dwarf", "small_pill", "small_v"]
var shapes_reference = shapes
var shape_picker: RandomNumberGenerator
var curr_shape

func pick_shape():
    play(shapes[shape_picker.randi() % shapes.size()])
    
#func play(animation):
    #$AnimatedSprite.play(animation)
    
#func stop():
    #$AnimatedSprite.stop()
    
#func pick_shape(animation):
#    if animation == "flying":    
#        curr_animation = color +"_flying"
#    else:
#        curr_animation = color +"_flying"
#    
    


func _ready():
    stop()
    shape_picker = RandomNumberGenerator.new()
    shape_picker.randomize()
    #shape_picker.seed = 1234
    
    if shape == null:
        shape = pick_shape()
    
    
        


