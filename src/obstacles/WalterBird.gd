extends Obstacle

export(String, "blue", "red", "yellow", "green") var color = null
var colors =  ["blue", "red", "yellow", "green"]
var colors_reference = colors

func pick_color():
    return controller.random_from(colors)
    
func pick_animation(animation):
    var animation_name = ""
    
    if animation == "flying":    
        animation_name = color +"_flying"
    else:
        animation_name = color +"_flying"
    
    return animation_name

func enter():
    stop()

    if color == null:
        color = pick_color()
    
    play(pick_animation("flying"))
