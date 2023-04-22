extends PanelContainer

signal get_ready()

export var star_path: NodePath
var star: Star

var position_format = "Best: %.1f m"

func hide_and_ready():
    set_visible(false)
    emit_signal("get_ready")

# Called when the node enters the scene tree for the first time.
func _ready():
    star = get_node(star_path)
    #pass # Replace with function body.
    
func _process(delta):
    #if star.retry
    pass
    
func unhide():
    set_visible(true)

func _on_RetryButton_button_up():
    hide_and_ready()


func _on_Star_max_max_position_changed(new_max_max):
    
    #new_max_max = new_max_max.x * 10
    #new_max_max = round(new_max_max)
    #new_max_max = float(new_max_max / 10)
    
    new_max_max = new_max_max.x / star.pixel_to_meter_conversion_factor
    
     
    var max_max_string = position_format % new_max_max
    
    $VBoxContainer/Label.text = max_max_string


func _on_Star_retry_dialogue():
    unhide()
