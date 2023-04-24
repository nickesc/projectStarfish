extends Obstacle

export var boost_power = 1500

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Area2D_body_entered(body):
    if body.is_in_group("star"):
        body.apply_central_impulse(Vector2(0,-1 * boost_power))
        $BoostEffect.play()
