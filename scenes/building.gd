extends Node3D


var type = "Office"
var area = "None"
var in_good_form = true
var map = null
var bubble = null

func have_thought(request_name):
	var new_bubble = load("res://scenes/thought_bubble.tscn").instantiate()
	new_bubble.map = map
	new_bubble.request = request_name
	bubble = new_bubble
	add_child(new_bubble)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bubble != null:
		bubble.position = get_viewport().get_camera_3d().unproject_position(position)
