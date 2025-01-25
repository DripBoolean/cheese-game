class_name Farmers extends Node3D

@export var Money = 100
@export var Milk_Supply = 10

@export var farms = 0
@export var farm_value = 0
@export var employees_per_farm = 0

@export var cows = 0
@export var cow_purchase_value = 0

@export var factories = 0
@export var factory_value = 0
@export var exployees_per_factory = 0

@export var employees = 0

var Expenses = 0
var Profit = 0
@export var goal_profit = 0

var Raw_Milk_Supply = 0

"""

"""
var My_Market_Value = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(farms):
		pass
	
	for i in range(cows):
		pass
	
	for i in range(factories):
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func place_cow(farm_to_place_cow_in : Node3D):
	pass

func place_buidling(building_to_place : PackedScene):
	pass

func decide_what_to_do():
	pass

##Either ask directly for a loan 
func ask_for_money():
	pass

func update_finances():
	
	
	pass

func _on_update_time_timeout() -> void:
	update_finances()
	decide_what_to_do()
