class_name Farmers extends Node3D

@export var Money = 100
@export var Milk_Supply = 10

@export var farms = 0
@export var farm_value = 0
@export var employees_per_farm = 0
@export var farm_maintenance = 0

@export var cows = 0
@export var cow_purchase_value = 0
@export var cow_maintenance = 0

@export var factories = 0
@export var factory_value = 0
@export var exployees_per_factory = 0
@export var factory_maintenance = 0

@export var employees = 0
@export var employee_wage = 0

@export var tile_height = 1
@export var tile_width = 1

@export var grid_height = 2
@export var grid_width = 2

var Expenses = 0
var Profit = 0

var Raw_Milk_Supply = 0

var My_Market_Value = 0

var Goal_Market_Value = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(farms):
		pass
	
	for i in range(cows):
		pass
	
	for i in range(factories):
		pass

func place_cow(farm_to_place_cow_in : Node3D):
	pass

func place_building(building_to_place : PackedScene):
	pass

func decide_what_to_do():
	"""
	Consider options based on the following priorities
	
	1. How close I am to my goal market value
	
		- if I am far away from my goal, be more extreme
		
		- if I am far above my goal, be more extreme
	
	2. How much money I have to attempt to make more money
	
		a. I don't have enough money :(
		
			- ask for money
			
				refusal = get mad
			
			- emergency sell extra supplies
			
		b. I have enough money :)
		
			- determine what I should purchase
			
				step one: hire more employees
				
				step two: buy more cows (if not enough space for cows)

	3. What supplies I have
	
	4. How much money I am making
	"""

##Either ask directly for a loan 
func ask_for_money():
	pass


func go_to_market():
	"""
	1. update market
	
	2. sell as much of my stock as possible
	"""

func update_finances():
	
	"""
	1. update current expenses with maintinance costs
	"""
	
	"""
	2. take away expenses and add profits to determine current change in money
	"""
	
	"""
	3. add that change to my current money
	"""
	
	"""
	4. determine current new market value
	"""
	
	"""
	5. reset expenses or profit for next update
	"""

func _on_update_time_timeout() -> void:
	go_to_market()
	update_finances()
	decide_what_to_do()
