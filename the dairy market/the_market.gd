class_name Market extends Node3D

@export var Demand = 0

##per Milk
@export var base_price = 1
@onready var Current_Price = 1

@export var price_scaling = 1


func demand_to_price():
	var price = log(50) - log(2*Demand)
	
func determine_price_of_milk():
	"""
	1. Take the Demand
	
	2. Take the Current Supply
	
	3. Figure this garbage out
	
		lower demand than supply -> price decreases 
		
			effects: this lowers the price, which increases the demand
		
		demand roughly equals supply -> price remains the same ---- player tries to maintain this
		
		higher demand than supply -> price increases
		
			effects: this increase the price, which decreases the demand
	"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
