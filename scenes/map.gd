extends Node3D



var buildings = [
	{"type": "Office", "position": Vector3(0, 0, 0)},
	{"type": "Office", "position": Vector3(3, 0, 0)},
	{"type": "Office", "position": Vector3(-3, 0, 0)},
	{"type": "Office", "position": Vector3(0, 0, 3)},
	{"type": "Office", "position": Vector3(0, 0, -3)},
]

func spawn_buildings():
	for building in buildings:
		var new_building = load("res://scenes/building.tscn").instantiate()
		new_building.type = building.type
		new_building.position = building.position
		add_child(new_building)

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_buildings()
	var new_bubble = load("res://scenes/thought_bubble.tscn").instantiate()
	new_bubble.position = $Player/Camera3D.unproject_position(buildings[0].position)
	#.add_child(new_bubble)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
