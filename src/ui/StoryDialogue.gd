extends PanelContainer

var curr_story_panel = 1



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_NextButton_button_up():
    
    if curr_story_panel==1:
        curr_story_panel = 2
        $VBoxContainer/Story1.set_visible(false)
        $VBoxContainer/Story2.set_visible(true)
        $VBoxContainer/CenterContainer2/NextButton.text = "close"
    elif curr_story_panel==2:
        curr_story_panel = 1
        $VBoxContainer/Story1.set_visible(true)
        $VBoxContainer/Story2.set_visible(false)
        $VBoxContainer/CenterContainer2/NextButton.text = "next"
        set_visible(false)
