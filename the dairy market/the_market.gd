class_name Market extends Node3D

@export var The_Farmers : Farmers = null

@export var Demand = 0

##per Milk
@onready var Current_Price = 1



func ratio_to_price_modulation(ratio : float)-> float:
	
	var modulation :float = log(ratio)/2 + 1
	
	return modulation

func modulation_to_demand_change(modulation : float) -> float:
	
	var demand_change : float = log(50) - log(5*modulation)
	
	return demand_change
	
func determine_price_of_milk():
	
	var demand_to_supply_ratio = Demand / The_Farmers.Supply
	
	var demand_modulation : float = ratio_to_price_modulation(demand_to_supply_ratio)
	
	var demand_change : float = modulation_to_demand_change(demand_modulation)
	
	#CUrrent
	"""
	1. Take the Demand
	
	2. Take the Current Supply
	
	3. Figure this garbage out
	
	make an equation that modulates the current price by the  factor generated below
	
	the lowr supply is than demand, the lower the price goes
	
		lower demand than supply -> price decreases 
		
			effects: this lowers the price, which increases the demand
		
		demand roughly equals supply -> price remains the same ---- player tries to maintain this
		
		higher demand than supply -> price increases
		
			effects: this increase the price, which decreases the demand
	
	these changes will affect demand slightly
	"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
