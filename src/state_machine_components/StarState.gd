class_name StarState
extends State

var star: Star

# Called when the node enters the scene tree for the first time.
func _ready():
    # wait for the root node to be ready
    yield(owner, "ready")
    # cast the `owner` variable to the `Player` type.
    star = owner as Star
    # check the parent was assigned correctly
    assert(star != null)
