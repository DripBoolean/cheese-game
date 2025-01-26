class_name Farmers extends Node3D

@export var Money = 1000000
@export var Milk_Supply = 50000

@export var farm_scene : PackedScene = null
@export var farms = 3
@export var farm_value = 50000
@export var cows_per_farm = 20
@export var employees_per_farm = 4
@export var farm_maintenance = 500

@export var cow_scene : PackedScene = null
@export var cows = 60
@export var cow_value = 1000
@export var milk_per_cow = 100
@export var cow_maintenance = 100

@export var factory_scene : PackedScene = null
@export var factories = 1
@export var factory_value = 150000
@export var employees_per_factory = 10
@export var factory_maintenance = 15000
@export var factory_milk_production = 7500
@export var price_to_process_each_milk = 1

var employees = 0
@export var employee_wage = 1000

@export var tile_height = 1
@export var tile_width = 1

@export var grid_height = 2
@export var grid_width = 2

@export var farm_location_x = 0
@export var farm_location_y = 0
var grid = []
var possible_placement_locations : Array[Vector2] = []

###----------------------------
##VVVVV actual variables VVVVV
###----------------------------

@export var shares = 200
var Expenses = 0
var Profit = 0

var Raw_Milk_Supply = 0
var Raw_Milk_I_Produce = 0
var Milk_I_Can_Refine = 0

var Goal_Market_Value : float = 5000000

@export var Base_Time : float = 300
@onready var time_left : float = Base_Time

@export var Max_Panic = 100
var Panic :float = 0

var my_farms : Array[Farm] = []
var my_cows : Array[Cow] = []
var my_factories : Array[Factory] = []

#100 000 a second

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.The_Farmers = self
	
	for x in range(grid_width + 1):
		var columun = []
		for y in range(grid_height + 1):
			columun.append(0)
		grid.append(columun)
	
	grid[farm_location_x][farm_location_y] = 1
	$farm_house.position = Vector3(farm_location_x * tile_width + tile_width/2 ,0, farm_location_y * tile_height + tile_height/2)
	update_placeable_locations(Vector2(farm_location_x, farm_location_y))
	
	for i in range(farms):
		place_building(farm_scene)
		
	for i in range(cows):
		place_cow()
	
	for i in range(factories):
		place_building(factory_scene)

	Raw_Milk_I_Produce = cows * milk_per_cow
	Milk_I_Can_Refine = factories * factory_milk_production

func update_placeable_locations(coord_placed_at : Vector2):
	grid[coord_placed_at.x][coord_placed_at.y] = 1
	if coord_placed_at.x - 1 >= 0:
		if grid[coord_placed_at.x - 1][coord_placed_at.y] == 0:
			possible_placement_locations.append(Vector2(coord_placed_at.x - 1, coord_placed_at.y))
	
	if coord_placed_at.x + 1 < grid_width:
		if grid[coord_placed_at.x + 1][coord_placed_at.y] == 0:
			possible_placement_locations.append(Vector2(coord_placed_at.x + 1, coord_placed_at.y))
	
	if coord_placed_at.y - 1 >= 0:
		if grid[coord_placed_at.x][coord_placed_at.y - 1] == 0:
			possible_placement_locations.append(Vector2(coord_placed_at.x, coord_placed_at.y - 1))
	
	if coord_placed_at.y + 1 < grid_height:
		if grid[coord_placed_at.x][coord_placed_at.y + 1] == 0:
			possible_placement_locations.append(Vector2(coord_placed_at.x, coord_placed_at.y + 1))
	

#func 
func place_cow():
	print("FARMERS BOUGHT COW")
	var new_cow = cow_scene.instantiate()
	for farm in my_farms:
		if farm.num_cow_slots_available > 0:
			farm.num_cow_slots_available -= 1
			farm.add_child(new_cow)
			new_cow.position = Vector3(randf_range(-tile_width/2.0, tile_width/2.0), 0,
										randf_range(-tile_height/2.0, tile_height/2.0))
			break
	#cows+=1

func buy_something(i_am_panicking : bool = false):
	if not i_am_panicking:
		if Money <= 0:
			return
	
	#if I make more raw milk than I produce, buy a factory
	if Raw_Milk_I_Produce > Milk_I_Can_Refine:
		#buy a new factory to compensate
		Money -= factory_value
		factories += 1
		global.The_Market.Farmers_Market_Value += factory_value
		Milk_I_Can_Refine += factory_milk_production
		
		global.The_Market.Recent_Farm_Purchases.append(factory_value)
		global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(factory_value)
		place_building(factory_scene)
		
	else:
		#figure out how much over production I have
		var overproduction = Milk_I_Can_Refine - Raw_Milk_I_Produce
		
		if overproduction > 0:
			#print('b')
			#buy farms or cows to make up the difference
			if cows < farms * cows_per_farm:
				for i in range(randi_range(clamp((farms * cows_per_farm - cows)/2, 1, (farms * cows_per_farm - cows)/2)
												, farms * cows_per_farm - cows)):
					global.The_Market.Recent_Farm_Purchases.append(cow_value)
					global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(cow_value)
					cows += 1
					place_cow()
			else:
				#print('c')
				Money -= farm_value
				farms += 1
				global.The_Market.Farmers_Market_Value += farm_value
				
				global.The_Market.Recent_Farm_Purchases.append(farm_value)
				global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(farm_value)
				place_building(farm_scene)
			
		else:
			#print('d')
			#if I somehow precisely have no overproduction, just buy more factories lol
			#I'll probably need them later anyway
			Money -= factory_value
			factories += 1
			global.The_Market.Farmers_Market_Value += factory_value
			Milk_I_Can_Refine += factory_milk_production
			
			global.The_Market.Recent_Farm_Purchases.append(factory_value)
			global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(factory_value)
			place_building(factory_scene)

func place_building(building_to_place : PackedScene):
	var location = possible_placement_locations.pop_at(randi_range(0, len(possible_placement_locations) - 1))
	update_placeable_locations(location)
	
	if building_to_place == farm_scene:
		print("FARMERS BOUGHT FARM")
		#farms+=1
		var new_farm = farm_scene.instantiate()
		add_child(new_farm)
		my_farms.append(new_farm)
		new_farm.position = Vector3(location.x * tile_width + tile_width/2 ,0, location.y * tile_height + tile_height/2)
		employees += employees_per_farm
		#employees_per_factory
	
	elif building_to_place == factory_scene:
		print("FARMERS BOUGHT FACTORY")
		#factories+=1
		var new_factory = factory_scene.instantiate()
		add_child(new_factory)
		my_factories.append(new_factory)
		new_factory.position = Vector3(location.x * tile_width + tile_width/2,0,location.y * tile_height + tile_height/2)
		employees += employees_per_factory

func investors_invested(amount : int):
	"""
	1. pay back the investors according to how much they sold 
		or gain money based on how much they bought
	
	2. increase panic based on the amount
	"""
	#var money_change = float(number_of_shares) * global.The_Market.Farmers_Market_Value
	Money += amount
	Panic -= (amount / global.The_Market.base_investment_amount) * 15
	Panic = clamp(Panic, 0, Max_Panic)
	
	
##Either ask directly for a loan 
func ask_for_money(for_building : bool = false):
	print("i asked for money")
	pass

func government_bought_milk(milk_amount : int):
	print("GOVERNMENT BOUGHT CHEESE")
	print(milk_amount)
	global.The_Market.Fake_Demand += milk_amount

func government_gave_subsidy(money_amount : int):
	print("GOVERNMENT GAVE SUBSIDY")
	Money += money_amount
	global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(money_amount)
	global.The_Market.Recent_Changes_in_Farm_Profit.append(money_amount)

func go_to_market():
	var cur_demand = global.The_Market.Demand
	var prev_supply = Milk_Supply
	Milk_Supply = clamp(Milk_Supply - cur_demand, 0, Milk_Supply)
	var actual_change = prev_supply - Milk_Supply
	
	var money_change = actual_change * global.The_Market.Current_Price_of_Milk
	Money += money_change
	print("MILK SOLD: " + str(actual_change))
	print("MONEY MADE: " + str(money_change))
	global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(
			money_change)
	global.The_Market.Recent_Changes_in_Farm_Profit.append(money_change)

func produce_milk():
	
	for cow in range(cows):
		Raw_Milk_Supply += milk_per_cow
	
	Raw_Milk_I_Produce = cows * milk_per_cow
	print("MILK I PRODUCE: " + str(Raw_Milk_Supply))
	
	var total_milk_made = 0
	
	for factory in my_factories:
		var new_Milk = (factory_milk_production *
						factory.employees_working_here / employees_per_factory)
		#Milk_I_Can_Refine = new_Milk
		if (Raw_Milk_Supply - new_Milk) <= 0:
			#Milk_Supply += Raw_Milk_Supply
			total_milk_made += Raw_Milk_Supply
			Raw_Milk_Supply = 0
			break
		Raw_Milk_Supply -= new_Milk
		total_milk_made += new_Milk
		
	Milk_I_Can_Refine = (factory_milk_production) * factories
	#print("Milk_I_Can_Refine: " + str(Milk_I_Can_Refine))
	Milk_Supply += total_milk_made
	print("MILK MADE: " + str(total_milk_made))
	print("FACTORIES I OWN: " + str(len(my_factories)))
	Money -= total_milk_made * price_to_process_each_milk
	global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(
			total_milk_made * price_to_process_each_milk)
	global.The_Market.Recent_Changes_in_Farm_Profit.append(
			total_milk_made * price_to_process_each_milk)

func take_expenses():
	
	var expenses = (farm_maintenance * farms + 
				factory_maintenance * factories +
				employees * employee_wage)
	print("EXPENSES: " + str(expenses))
	Money -= expenses
	global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(expenses)
	global.The_Market.Recent_Changes_in_Farm_Profit.append(
			expenses)
	
func decide_what_to_do():
	print("FARM DECISION")
	
	var cur_value_to_desired_value = (global.The_Market.Farmers_Market_Value / Goal_Market_Value)
	print("CURRENT VALUE PROGRESS: " + str(cur_value_to_desired_value))
	
	var ratio_of_time_left = time_left / Base_Time
	print("RATIO OF TIME LEFT: " + str(ratio_of_time_left))
	##Chance I have to pick a more panicked option
	var Panic_Ratio = Panic / Max_Panic
	
	Panic += ((2 - ratio_of_time_left - cur_value_to_desired_value) 
					* $decision_time.wait_time) * 1
	Panic = clamp(Panic, 0, Max_Panic)
	
	print("CURRENT PANIC: " + str(Panic))
	print(((2 - ratio_of_time_left - cur_value_to_desired_value) 
					* $decision_time.wait_time) * 1)
	$decision_time.wait_time *=  clamp($decision_time.wait_time * (1 - Panic_Ratio), 0.1, 3)
	$decision_time.wait_time = clamp($decision_time.wait_time, 1, 3)
	
	if cur_value_to_desired_value < 1:
		
		##I need to make more money
		
		##Do I have any money???
		
		if Money > 0:
			#yes I have money to burn
			#buy something a random number of times
			
			for i in range(randi_range(1, 3)):
				buy_something()
			
			#if milk production is less than demand, buy an extra building
			if global.The_Market.Demand < Milk_I_Can_Refine:
				buy_something(true)
		else:
			if Panic >= 80:
				#if I am REALLY panicked for value, just buy stuff anyway and ask for money
				buy_something()
				ask_for_money(true)
			elif Panic < 80 and Panic >= 40:
				#if I am kind of panicked, ask for some money or for the government to buy cheese
				buy_something()
				if randf() < .5:
					buy_something()
				else:
					ask_for_money(true)
			elif Panic < 40 and Panic >= 10:
				#if I am a little panicked, do whatever
				if randf() < .75:
					buy_something()
				else:
					ask_for_money()
			else:
				#if I am not really panicked, figure out if I am in the red
				Expenses = (farm_maintenance * farms + 
								factory_maintenance * factories +
								employees * employee_wage)
				if Expenses < 0:
					#chill out for some more money
					#in otherwords, do nothing
					pass
				else:
					ask_for_money()
	else:
		
		##I have the money I need
		
		##No need to panic since I'm already good to go
		Panic = 0

func _on_decision_time_timeout() -> void:
	print()
	decide_what_to_do()

func _on_update_finances_time_timeout() -> void:
	time_left -= $update_finances_time.wait_time
	print()
	print("FARM UPDATE")
	go_to_market()
	produce_milk()
	take_expenses()
	print("CURRENT MILK SUPPLY: " + str(Milk_Supply))
	print("CURRENT FARM MONEY: " + str(Money))
	#decide_what_to_do()
