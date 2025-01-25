extends Node3D



var building_generation = [
	{"type": "Office", "position": Vector3(0, 0, 0)},
	{"type": "Office", "position": Vector3(3, 0, 0)},
	{"type": "Office", "position": Vector3(-3, 0, 0)},
	{"type": "Office", "position": Vector3(0, 0, 3)},
	{"type": "Office", "position": Vector3(0, 0, -3)},
]

var loaded_buildings = []

func spawn_buildings():
	for building in building_generation:
		var new_building = load("res://scenes/building.tscn").instantiate()
		new_building.type = building.type
		new_building.position = building.position
		loaded_buildings.append(new_building)
		add_child(new_building)

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_buildings()
	loaded_buildings[0].have_thought()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
