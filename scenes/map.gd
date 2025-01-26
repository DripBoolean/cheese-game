extends Node3D

var building_generation = [
	{"type": "Office", "area": "city", "position": Vector3(0, 0, 0)},
	{"type": "Office", "area": "city", "position": Vector3(3, 0, 0)},
	{"type": "Office", "area": "city",  "position": Vector3(-3, 0, 0)},
	{"type": "Office", "area": "city", "position": Vector3(0, 0, 3)},
	{"type": "Office", "area": "city", "position": Vector3(0, 0, -3)},
	{"type": "TownHouse", "area": "suburb", "position": Vector3(9, 0, 0)},
	{"type": "TownHouse", "area": "farm", "position": Vector3(12, 0, 0)},
	{"type": "TownHouse", "area": "suburb", "position": Vector3(6, 0, 0)},
	{"type": "TownHouse", "area": "suburb", "position": Vector3(9, 0, 3)},
	{"type": "TownHouse", "area": "suburb", "position": Vector3(9, 0, -3)},
]

var money = 1000000.0
var political_points = 0.0
var cheese = 0.0
var cheese_max = 100.0
var tax_income = 100000.0
var city_health = 100.0
var time_till_next_election = 60.0
var request_interval = 3.0
var time_since_last_request = 0.0

var loaded_buildings = []

func spawn_buildings():
	for building in building_generation:
		var new_building = load("res://scenes/building.tscn").instantiate()
		new_building.type = building.type
		new_building.position = building.position
		new_building.map = self
		new_building.area = building.area
		loaded_buildings.append(new_building)
		add_child(new_building)

func enact_request(request_outcome):
	if request_outcome == "give_farm_money":
		political_points += 5.0
		money -= 1000000.0
		#$TheMarket.government_gave_subsidy(1000)
	if request_outcome == "give_city_money":
		political_points += 2.0
		money -= 1000000.0
	if request_outcome == "give_suburb_money":
		political_points += 1.0
		money -= 2000000.0
	if request_outcome == "buy_milk":
		#$TheMarket.government_bought_milk(5000)
		money -= 5000000.0
		cheese += 4
	if request_outcome == "sell_cheese":
		money += 6000000.0
		cheese -= 2

# Called when the node enters the scene tree for the first time.
func _ready():
	$EventController.map = self
	randomize()
	spawn_buildings()
	
func spawn_bubble(area, request):
	var building
	while true:
		building = loaded_buildings.pick_random()
		if building.area == area:
			break
	
	building.have_thought(request)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_till_next_election -= delta
	
	$UI/CanvasLayer/HUD/ProgressBar.value = political_points
	$UI/Time.text = "Time: %f" % [time_till_next_election]
	$UI/Money.text = "%f" % [money]
	$UI/Cheese.text = "%f" % [cheese]

	time_since_last_request += delta
	
	if time_since_last_request > request_interval:
		$EventController.update()
		time_since_last_request = 0.0
