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
var suburb_health = 100.0
var time_till_next_election = 60.0
var request_interval = 3.0
var time_since_last_request = 0.0

var loaded_buildings = []
var num_city_buildings = 0
var healthy_city_buildings = 0
var num_suburb_buildings = 0
var healthy_suburb_buildings = 0
var num_farm_buildings = 0
var healthy_farm_buildings = 0

func format_number(n: int) -> String:
	if n >= 1_000_000:
		var i:float = snapped(float(n)/1000000, .01)
		return str(i).replace(",", ".") + "M"
	elif n >= 1_000:
		var i:float = snapped(float(n)/1000, .01)
		return str(i).replace(",", ".") + "k"
	else:
		return str(n)

func spawn_buildings():
	loaded_buildings = $Buildings.get_children()
	for building in loaded_buildings:
		building.map = self
		match building.area:
			"city":
				num_city_buildings += 1
			"suburb":
				num_suburb_buildings += 1
			"farm":
				num_farm_buildings += 1
	healthy_city_buildings = num_city_buildings
	healthy_suburb_buildings = num_suburb_buildings
	healthy_farm_buildings = num_farm_buildings

	#for building in building_generation:
		#var new_building = load("res://scenes/building.tscn").instantiate()
		#new_building.type = building.type
		#new_building.position = building.position
		#new_building.map = self
		#new_building.area = building.area
		#loaded_buildings.append(new_building)
		#add_child(new_building)

func enact_request(request_outcome):
	if request_outcome == "give_farm_money":
		political_points += 5.0
		money -= 1000000.0
		$TheFarmers.government_gave_subsidy(1000)
	if request_outcome == "give_city_money":
		political_points += 2.0
		money -= 1000000.0
		city_health += 25.0
	if request_outcome == "give_suburb_money":
		political_points += 1.0
		money -= 2000000.0
		suburb_health += 25.0
	if request_outcome == "buy_milk":
		$TheFarmers.government_bought_milk(5000)
		money -= 5000000.0
		cheese += 4
	if request_outcome == "sell_cheese":
		money += 6000000.0
		cheese -= 2
		
func spawn_bubble(area, request):
	var building
	while true:
		building = loaded_buildings.pick_random()
		if building.area == area:
			break
	
	building.have_thought(request)

func repair_buildings(type, amount):
	var buildings_repaired = 0
	var buildings_sampled = 0
	while buildings_repaired < amount:
		buildings_sampled += 1
		var sample_building = loaded_buildings.pick_random()
		if buildings_sampled > 100:
			print("Too many samples")
			break
		if sample_building.area != type:
			continue
		if sample_building.in_good_form:
			continue
		sample_building.repair()
		buildings_repaired += 1

func damage_buildings(type, amount):
	var buildings_damaged = 0
	var buildings_sampled = 0
	while buildings_damaged < amount:
		buildings_sampled += 1
		if buildings_sampled > 100:
			print("Too many samples")
			break
		var sample_building = loaded_buildings.pick_random()
		print(buildings_sampled)
		if sample_building.area != type:
			continue
		if !sample_building.in_good_form:
			
			continue
	
		sample_building.damage()
		buildings_damaged += 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$EventController.map = self
	randomize()
	spawn_buildings()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_till_next_election -= delta
	
	$UI/CanvasLayer/HUD/ProgressBar.value = political_points
	$UI/Time.text = "Time: %f" % [time_till_next_election]
	$UI/Money.text = "%s" % [format_number(money)]
	$UI/Cheese.text = "%d" % [int(cheese)]
	
	money += tax_income * delta * (0.1 + (0.5 * city_health / 100.0) + (0.4 * suburb_health / 100.0))
	city_health -= 20.0 * delta
	if city_health <= 0.0:
		city_health = 0.0
	if city_health >= 100.0:
		city_health = 100.0
	suburb_health -= 20.0 * delta
	if suburb_health <= 0.0:
		suburb_health = 0.0
	if suburb_health >= 100.0:
		suburb_health = 100.0
	var new_healthy_city_buildings = int((city_health / 100.0) * num_city_buildings)
	var delta_healthy_city_buildings = new_healthy_city_buildings - healthy_city_buildings
	if delta_healthy_city_buildings > 0:
		repair_buildings("city", delta_healthy_city_buildings)
	if delta_healthy_city_buildings < 0:
		damage_buildings("city", -delta_healthy_city_buildings)
	healthy_city_buildings = new_healthy_city_buildings
	var new_healthy_suburb_buildings = int((suburb_health / 100.0) * num_suburb_buildings)
	var delta_healthy_suburb_buildings = new_healthy_suburb_buildings - healthy_suburb_buildings
	if delta_healthy_suburb_buildings > 0:
		repair_buildings("suburb", delta_healthy_suburb_buildings)
	if delta_healthy_suburb_buildings < 0:
		damage_buildings("suburb", -delta_healthy_suburb_buildings)
	healthy_suburb_buildings = new_healthy_suburb_buildings
		
	
	time_since_last_request += delta
	
	if time_since_last_request > request_interval:
		$EventController.update()
		time_since_last_request = 0.0
