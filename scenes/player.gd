extends Node3D

const SPEED = 5.0
const SCROLL_SPEED = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_dir2 := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var input_dir3 := Vector3(input_dir2.x, 0, input_dir2.y)
	
	position += SPEED * input_dir3 * delta
