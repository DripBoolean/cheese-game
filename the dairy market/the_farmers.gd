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
	pass

func place_building(building_to_place : PackedScene):
	if building_to_place == farm_scene:
		pass
	elif building_to_place == factory_scene:
		pass

func investors_invested(number_of_shares : int):
	"""
	1. pay back the investors according to how much they sold 
		or gain money based on how much they bought
	
	2. increase panic based on the amount
	"""
	var money_change = float(number_of_shares) * global.The_Market.Farmers_Market_Value / shares
	Money += money_change
	
	if money_change < 0:
		pass
	else:
		pass
	
	
##Either ask directly for a loan 
func ask_for_money():
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
	global.The_Market.change_Farm_Value(money_change)
	global.The_Market.Recent_Changes_in_Farm_Value.append(money_change)

func produce_milk():
	
	for cow in range(cows):
		Raw_Milk_Supply += cows * 1
	
	var total_milk_made = 0
	for factory in my_factories:
		var new_Milk = (factory.Milk_Production *
						factory.employees_working_here / employees_per_factory)
		
		if (Raw_Milk_Supply - new_Milk) <= 0:
			Milk_Supply += Raw_Milk_Supply
			total_milk_made += Raw_Milk_Supply
			Raw_Milk_Supply = 0
			break
		
		total_milk_made += new_Milk
	
	Money -= total_milk_made * price_to_process_each_milk
	global.The_Market.Recent_Changes_in_Farm_Value.append(
			total_milk_made * price_to_process_each_milk)


func take_expenses():
	
	Money -= (farm_maintenance * farms + 
				factory_maintenance * factories +
				employees * employee_wage)


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
	
	if cur_value_to_desired_value < 1:
		
		##I need to make more money
		
		##Do I have any money???
		
		if Money > 0:
			#yes I have money to burn
			
			#if I have raw milk, I should not have raw milk
			if Raw_Milk_Supply > 0:
				#buy a new factory to compensate
				pass
			else:
				#figure out how much over production I have
				var overproduction = Milk_I_Can_Refine - Raw_Milk_I_Produce
				#buy farms to make up the difference
				if overproduction > 0:
					pass
				else:
					#if I somehow precisely have no overproduction, just buy more factories lol
					#I'll probably need them later anyway
					pass
		else:
			#if I am REALLY panicked for value, just buy stuff anyway lol
			
			#if I am kind of panicked, ask for some money or for the government to buy cheese
			
			#if I am not really panicked, figure out if I am in the red
			Expenses = (farm_maintenance * farms + 
							factory_maintenance * factories +
							employees * employee_wage)
			if Expenses < 0:
				#chill out for some more money
				
				pass
			
			pass
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
