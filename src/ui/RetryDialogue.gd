extends PanelContainer

signal get_ready()

export var star_path: NodePath
var star: Star

var position_format = "Longest Throw:\n %.1f m"

func swap_to_store():
    $Retry.set_visible(false)
    $Store.set_visible(true)

func swap_to_retry():
    $Store.set_visible(false)
    $Retry.set_visible(true)
    

func hide_and_ready():
    swap_to_retry()
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
    swap_to_retry()

func _on_RetryButton_button_up():
    hide_and_ready()


func _on_Star_max_max_position_changed(new_max_max):
    
    #new_max_max = new_max_max.x * 10
    #new_max_max = round(new_max_max)
    #new_max_max = float(new_max_max / 10)
    
    new_max_max = new_max_max.x / star.pixel_to_meter_conversion_factor
    
     
    var max_max_string = position_format % new_max_max
    
    $Retry/BestLabel.text = max_max_string


func _on_Star_retry_dialogue():
    unhide()


func _on_StoreButton_button_up():
    swap_to_store()


func _on_BackButton_button_up():
    swap_to_retry() # Replace with function body.
