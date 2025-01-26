class_name Farmers extends Node3D

@export var Money = 100
@export var Milk_Supply = 50

@export var farm_scene : PackedScene = null
@export var farms = 2
@export var farm_value = 10
@export var cows_per_farm = 10
@export var employees_per_farm = 2
@export var farm_maintenance = 0.5

@export var cow_scene : PackedScene = null
@export var cows = 10
@export var cow_value = 2
@export var cow_maintenance = 0.1

@export var factory_scene : PackedScene = null
@export var factories = 1
@export var factory_value = 30
@export var employees_per_factory = 5
@export var factory_maintenance = 3
@export var factory_milk_production = 10
@export var price_to_process_each_milk = 0.05

var employees = 0
@export var employee_wage = 1

@export var tile_height = 1
@export var tile_width = 1

@export var grid_height = 2
@export var grid_width = 2

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

var Goal_Market_Value : float = 0

@export var Base_Time : float = 300
@onready var time_left : float = Base_Time

@export var Max_Panic = 100
var Panic :float = 0

var my_farms : Array[Farm] = []
var my_cows : Array[Cow] = []
var my_factories : Array[Factory] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.The_Farmers = self
	
	for i in range(farms):
		var new_farm = farm_scene.instantiate()
		new_farm.num_cow_slots_available = cows_per_farm
		add_child(new_farm)
	
	for i in range(cows):
		var new_cow = cow_scene.instantiate()
		add_child(new_cow)
	
	for i in range(factories):
		var new_factory = factory_scene.instantiate()
		add_child(new_factory)

#func 
func place_cow(farm_to_place_cow_in : Node3D):
	cows+=1

func buy_something(i_am_panicking : bool = false):
	if not i_am_panicking:
		if Money <= 0:
			return
	
	#if I make more raw milk than I produce, buy a factory
	if Raw_Milk_I_Produce > Milk_I_Can_Refine:
		#buy a new factory to compensate
		Money -= factory_value
		Milk_I_Can_Refine += factory_milk_production
		
		global.The_Market.Recent_Farm_Purchases.append(factory_value)
		global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(factory_value)
		place_building(factory_scene)
		
	else:
		#figure out how much over production I have
		var overproduction = Milk_I_Can_Refine - Raw_Milk_I_Produce
		;
		if overproduction > 0:
			#buy farms or cows to make up the difference
			if cows < farms * cows_per_farm:
				Raw_Milk_I_Produce += 1
				pass
			else:
				
				Money -= farm_value
				global.The_Market.Recent_Farm_Purchases.append(farm_value)
				global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(farm_value)
				place_building(farm_scene)
			
		else:
			#if I somehow precisely have no overproduction, just buy more factories lol
			#I'll probably need them later anyway
			Money -= factory_value
			Milk_I_Can_Refine += factory_milk_production
			
			global.The_Market.Recent_Farm_Purchases.append(factory_value)
			global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(factory_value)
			place_building(factory_scene)

func place_building(building_to_place : PackedScene):
	if building_to_place == farm_scene:
		farms+=1
		
		pass
		#employees_per_factory
	
	elif building_to_place == factory_scene:
		factories+=1
		pass

func investors_invested(amount : int):
	"""
	1. pay back the investors according to how much they sold 
		or gain money based on how much they bought
	
	2. increase panic based on the amount
	"""
	#var money_change = float(number_of_shares) * global.The_Market.Farmers_Market_Value
	Money += amount
	Panic += (amount / global.The_Market.base_investment_cost) * 15
	
	
##Either ask directly for a loan 
func ask_for_money(for_building : bool = false):
	print("i asked for money")
	pass

func government_bought_milk(milk_amount : int):
	pass

func government_gave_subsidy(money_amount : int):
	pass

func go_to_market():
	var cur_demand = global.The_Market.Demand
	var prev_supply = Milk_Supply
	Milk_Supply = clamp(Milk_Supply - cur_demand, 0, Milk_Supply)
	
	var actual_change = prev_supply - Milk_Supply
	
	var money_change = actual_change * global.The_Market.Current_Price_of_Milk
	Money += money_change
	global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(
			money_change)
	global.The_Market.Recent_Changes_in_Farm_Profit.append(money_change)

func produce_milk():
	
	for cow in range(cows):
		Raw_Milk_Supply += cows * 1
		
	Raw_Milk_I_Produce = cows
	
	var total_milk_made = 0
	for factory in my_factories:
		var new_Milk = (factory.Milk_Production *
						factory.employees_working_here / employees_per_factory)
		Milk_I_Can_Refine = new_Milk
		if (Raw_Milk_Supply - new_Milk) <= 0:
			Milk_Supply += Raw_Milk_Supply
			total_milk_made += Raw_Milk_Supply
			Raw_Milk_Supply = 0
			break
		
		total_milk_made += new_Milk
	
	Money -= total_milk_made * price_to_process_each_milk
	global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(
			total_milk_made * price_to_process_each_milk)
	global.The_Market.Recent_Changes_in_Farm_Profit.append(
			total_milk_made * price_to_process_each_milk)

func take_expenses():
	
	var expenses = (farm_maintenance * farms + 
				factory_maintenance * factories +
				employees * employee_wage)
	Money -= expenses
	global.The_Market.Recent_Changes_in_Farmers_Market_Value.append(expenses)
	global.The_Market.Recent_Changes_in_Farm_Profit.append(
			expenses)
	
func decide_what_to_do():
	
	
	"""
	Consider options based on the following priorities
	
	1. How close I am to my goal market value
	
		- if I am far away from my goal, be more extreme
		
		- if I am far above my goal, be more extreme
	"""
	var cur_value_to_desired_value = (global.The_Market.Dairy_Market_Value / Goal_Market_Value)
	
	var ratio_of_time_left = time_left / Base_Time
	
	##Chance I have to pick a more panicked option
	var Panic_Ratio = Panic / Max_Panic
	
	Panic += ((2 - ratio_of_time_left - cur_value_to_desired_value) 
					* $decision_time.wait_time) * 1
	
	$decision_time.wait_time *=  $decision_time.wait_time * (1 - Panic_Ratio)
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
				if randf() > .5:
					buy_something()
				else:
					ask_for_money(true)
			elif Panic < 40 and Panic >= 10:
				#if I am a little panicked, do whatever
				if randf() > .75:
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
				

		"""
		Options I have:
			
			buy more milk production
			
			buy more farm / cows
			
			#ways my value can increase
			
			i buy more stuff
			
			i make more milk
			
			in other words, BUY MORE STUFF
			
			other things I could do
			
			- lower employee wages
			
			- 
		"""
		
	else:
		
		##I have the money I need
		
		##No need to panic since I'm already good to go
		Panic = 0

	
	"""
	2. How much money I have to attempt to make more money
	
		a. I don't have enough money :(
			
			low panic = 
				- ask for money
				
					refusal = get mad
				
				- emergency sell extra supplies
			
			high panic = 
			
				- act like I have enough money
			
		b. I have enough money :)
		
			- determine what I should purchase
			
				step one: hire more employees
				
				step two: buy more cows (if not enough space for cows)

	3. What supplies I have
	
	4. How much money I am making
	"""

func _on_decision_time_timeout() -> void:
	decide_what_to_do()

func _on_update_finances_time_timeout() -> void:
	time_left -= $update_finances_time.wait_time
	go_to_market()
	produce_milk()
	take_expenses()
	#decide_what_to_do()
