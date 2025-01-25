extends Node3D


var buildings = [
	{"type": "Office", "position": Vector3(0, 0, 0)},
]

func spawn_buildings():
	for building in buildings:
		var new_building = load("res://scenes/building.tscn").instantiate()
		new_building.type = building.type
		new_building.position = position
		add_child(new_building)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_buildings()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
