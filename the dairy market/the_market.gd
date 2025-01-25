class_name Market extends Node3D

@export var Demand = 150
@export var Max_Demand = 300
@export var Min_Demand = 10

@export var Fake_Demand = 0

##per Milk
@export var Baseline_Price_of_Milk : float = 1
@onready var Current_Price_of_Milk : float = Baseline_Price_of_Milk

var Farmers_Market_Value = 10

var Last_Investment_Amount = 0

var Recent_Farm_Purchases = []
var Recent_Changes_in_Farmers_Market_Value = []
var Recent_Changes_in_Farm_Value = []
var Recent_Changes_in_Milk_Value = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.The_Market = self
	var farmer_ref : Farmers = global.The_Farmers
	var current_farmer_assets = (farmer_ref.cows * farmer_ref.cow_value
								+ farmer_ref.farms * farmer_ref.farm_value
								+ farmer_ref.factories * farmer_ref.factory_value
								+ farmer_ref.Money
								+ farmer_ref.Milk_Supply * Current_Price_of_Milk
								+ farmer_ref.Raw_Milk_Supply * Current_Price_of_Milk / 2.0)
	
	Farmers_Market_Value = current_farmer_assets
	#Recent_Changes_in_Farm_Value.append()

func update_market():
	determine_price_of_milk()

func ratio_to_price_modulation(ratio : float)-> float:
	
	var modulation :float = log(ratio)/2 + 1
	
	return modulation

func modulation_to_demand_change(modulation : float) -> float:
	
	var demand_change : float = log(50) - log(5*modulation)
	
	return demand_change

##external investors decide to invest in the dairy market
func investment_in_farmers():
	var amount_i_am_going_to_invest = 0
	
	var chance_i_invest = 50
	var chance_i_do_nothing = 40
	var chance_i_sell = 10
	
	var total_farm_purchases = 0
	var number_of_farm_purchaes = len(Recent_Farm_Purchases)
	for value in Recent_Farm_Purchases:
		total_farm_purchases += Recent_Farm_Purchases
	
	Recent_Farm_Purchases.clear()
	
	var total_recent_farm_profits = 0
	for value in Recent_Changes_in_Farm_Value:
		total_recent_farm_profits += value
		
	Recent_Changes_in_Farm_Value.clear()
	
	var total_recent_Milk_Price_changes = 0
	for value in Recent_Changes_in_Milk_Value:
		total_recent_Milk_Price_changes += value
	
	Recent_Changes_in_Milk_Value.clear()
	
	var Recent_Changes_in_Farmers_Market_Value = 0
	
	##change investment chances based on recent purchases
	for i in range(number_of_farm_purchaes):
		pass
	
	##
	
	##change chances based on total money spent
	
	##change chances based on the average value changes
	
	##change based on the recent average 
	"""
	+1. Look at how much their networth has increased
	
	+++ 2. Look at how much they have purchased recently
	
	++3. Look at the recent trend of Milk prices
	
	
	The greater these 3 factors are, the more likely the Investors invest
		and the lower the chance is that they sell
	
	Sometimes they might buy or sell anyways
	"""

func direct_demand_change(change : float):
	pass

func direct_price_change(change : float):
	pass


"""
ALTER FARMER VALUE BASED ON WHAT THEY HAVE IN INVENTORY AT THE TIME WHEN THE MILK PRICE CHANGES
"""
func determine_price_of_milk():
	var demand_to_supply_ratio = 1
	
	if global.The_Farmers.Supply == 0:
		demand_to_supply_ratio = 3
	else:
		demand_to_supply_ratio = clamp(Demand / global.The_Farmers.Supply, 0.5, 3)
	
	var price_modulation : float = ratio_to_price_modulation(demand_to_supply_ratio)
	
	price_modulation *= randf_range(0.9, 1.1)
	
	var demand_change : float = modulation_to_demand_change(price_modulation)
	
	demand_change *= randf_range(0.9, 1.1)
	
	var prev_price = Current_Price_of_Milk
	Current_Price_of_Milk *= price_modulation
	Recent_Changes_in_Milk_Value.append(Current_Price_of_Milk - prev_price)
	
	Demand *= demand_change
	Demand = clamp(Demand, Min_Demand, Max_Demand)
	
	#CUrrent

	"""	
	make an equation that modulates the current price by the factor generated below
	
	the lowr supply is than demand, the lower the price goes
	
		lower demand than supply -> price decreases 
		
			effects: this lowers the price, which increases the demand
		
		demand roughly equals supply -> price remains the same ---- player tries to maintain this
		
		higher demand than supply -> price increases
		
			effects: this increase the price, which decreases the demand
	these changes will affect demand slightly
	"""

func _on_market_update_time_timeout() -> void:
	determine_price_of_milk()

func _on_investment_update_timeout() -> void:
	investment_in_farmers()
