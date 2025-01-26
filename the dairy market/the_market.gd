class_name Market extends Node3D

@export var Demand = 15000
@export var Max_Demand = 1000000
@export var Min_Demand = 100

@export var Fake_Demand : int = 0

##per Milk
@export var Baseline_Price_of_Milk : float = 10
@onready var Current_Price_of_Milk : float = Baseline_Price_of_Milk

@export var base_investment_amount = 300000

var Farmers_Market_Value = 10

var Last_Investment_Amount = 0

var Recent_Farm_Purchases = []
var Recent_Changes_in_Farmers_Market_Value = []
var Recent_Changes_in_Farm_Profit = []
var Recent_Changes_in_Milk_Value = []
#--- haven't done yet
var Recent_Changes_in_Employment = []


####-------------------------
##INVESTMENT GARBARGE

@export var weight_of_items_purchased = 20
@export var min_items_purchased_for_max_happy = 10

@export var weight_of_money_spent = 10

@export var weight_of_Farmers_Market_Value = 20
@export var min_change_for_max_happy = 500000

@export var weight_of_farm_profit = 10

@export var weight_of_milk_value = 5

@export var weight_of_emploment_changes = 30

####-------------------------

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.The_Market = self
	call_deferred("set_up_farmer_data")
	#Recent_Changes_in_Farm_Value.append()
func set_up_farmer_data():
	var farmer_ref : Farmers = global.The_Farmers
	var current_farmer_assets = (farmer_ref.cows * farmer_ref.cow_value
								+ farmer_ref.farms * farmer_ref.farm_value
								+ farmer_ref.factories * farmer_ref.factory_value
								+ farmer_ref.Money
								+ farmer_ref.Milk_Supply * Current_Price_of_Milk
								+ farmer_ref.Raw_Milk_Supply * Current_Price_of_Milk / 2.0)
	
	Farmers_Market_Value = current_farmer_assets

func update_market():
	determine_price_of_milk()

func ratio_to_price_modulation(ratio : float)-> float:
	
	var modulation : float = 2 - (log(50)/log(10) - log(5*ratio)/log(10))#:float = log(ratio)/2 + 1
	
	return modulation

func modulation_to_demand_change(modulation : float) -> float:
	
	var demand_change : float = log(50)/log(10) - log(5*modulation)/log(10)
	return demand_change

##external investors decide to invest in the dairy market
func investment_in_farmers():
	var amount_i_am_going_to_invest = 0
	
	var chance_i_invest :float = 50
	var chance_i_sell : float = 50
	
	var total_farm_purchases = 0
	var number_of_farm_purchases = len(Recent_Farm_Purchases)
	for value in Recent_Farm_Purchases:
		total_farm_purchases += value
	
	Recent_Farm_Purchases.clear()
	
	var total_recent_farm_profits = 0
	for value in Recent_Changes_in_Farm_Profit:
		total_recent_farm_profits += value
		
	Recent_Changes_in_Farm_Profit.clear()
	
	var total_recent_Milk_Price_changes = 0
	for value in Recent_Changes_in_Milk_Value:
		total_recent_Milk_Price_changes += value
	
	Recent_Changes_in_Milk_Value.clear()
	
	var total_change_in_Farmers_Market_Value = 0
	for value in Recent_Changes_in_Farmers_Market_Value:
		total_change_in_Farmers_Market_Value += value
		
	Recent_Changes_in_Farmers_Market_Value.clear()
	
	##change investment chances based on recent purchases
	
	var invest_change_num_purchases = clamp(number_of_farm_purchases / min_change_for_max_happy, 0.5, 2)
	
	if invest_change_num_purchases < 0:
		invest_change_num_purchases = -1.0 / invest_change_num_purchases
	#print(invest_change_num_purchases)
	
	invest_change_num_purchases *= weight_of_items_purchased
	chance_i_invest += invest_change_num_purchases
	chance_i_sell -= invest_change_num_purchases
	
	##change investment chances based on amount spent
	
	var invest_change_money_spent = clamp(total_farm_purchases / min_change_for_max_happy, 0.5, 2)
	if invest_change_money_spent < 0:
		invest_change_money_spent = -1.0 / invest_change_money_spent
	#print(invest_change_money_spent)
	invest_change_money_spent *= weight_of_money_spent
	chance_i_invest += invest_change_money_spent
	chance_i_sell -= invest_change_money_spent
	
		
	##change chances based on the changes in Milk Price
	
	var previous_milk_price = Current_Price_of_Milk - total_recent_Milk_Price_changes
	
	var invest_change_milk = clamp(Current_Price_of_Milk / previous_milk_price, 0.5, 2)
	
	if invest_change_milk < 0:
		invest_change_milk = -1.0 / invest_change_milk
	#print(invest_change_milk)
	invest_change_milk *= weight_of_milk_value
	chance_i_invest += invest_change_milk
	chance_i_sell -= invest_change_milk
	
	##change chances based on the changes in Farmers Value
	var invest_change_value = clamp(total_change_in_Farmers_Market_Value / min_change_for_max_happy, 0.5, 2)
	
	if invest_change_value < 0:
		invest_change_value = -1.0 / invest_change_value
	#print(invest_change_value)
	invest_change_value *= weight_of_Farmers_Market_Value
	chance_i_invest += invest_change_value
	chance_i_sell -= invest_change_value
	
	
	
	chance_i_invest = clamp(chance_i_invest, 0, 100)
	chance_i_sell = clamp(chance_i_sell, 0, 100)
	##determine investment total
	var amount = 0
	if randf() < chance_i_invest/ 100.0:
		##they choose to invest
		amount = base_investment_amount *  clamp(chance_i_invest / chance_i_sell, 0, 2)
	else:
		##they choose not to invest
		amount = -base_investment_amount *  clamp(chance_i_sell / chance_i_invest, 0, 2)
	
	print("INVESTMENTS")
	print("AMOUNT: " + str(amount))
	print(chance_i_invest)
	print(chance_i_sell)
	
	global.The_Farmers.investors_invested(amount)
	#Farmers_Market_Value += total_change_in_Farmers_Market_Value + total_recent_Milk_Price_changes + total_farm_purchases

func direct_demand_change(change : float):
	pass

func direct_price_change(change : float):
	pass

func determine_price_of_milk():
	print("MARKET ALTERATIONS")
	var demand_to_supply_ratio = 1
	
	if global.The_Farmers.Milk_Supply == 0:
		demand_to_supply_ratio = 2
	else:
		demand_to_supply_ratio = clamp((Demand + Fake_Demand) / global.The_Farmers.Milk_Supply, 0.75, 2)
	
	Fake_Demand = clamp(Fake_Demand/2 - 50, 0, 100000)
	
	var price_modulation : float = ratio_to_price_modulation(demand_to_supply_ratio)
	
	price_modulation *= randf_range(0.9, 1.1)
	print("PRICE MODULATION: " + str(price_modulation))
	var demand_change : float = modulation_to_demand_change(demand_to_supply_ratio)
	
	demand_change *= randf_range(0.9, 1.1)
	print("DEMAND CHANGE: " + str(demand_change))
	
	var prev_price = Current_Price_of_Milk
	Current_Price_of_Milk *= price_modulation
	Recent_Changes_in_Milk_Value.append(Current_Price_of_Milk - prev_price)
	
	Demand *= demand_change
	Demand = clamp(Demand, Min_Demand, Max_Demand)
	
	var current_supply_worth = global.The_Farmers.Milk_Supply * Current_Price_of_Milk
	var previous_supply_worth = global.The_Farmers.Milk_Supply * prev_price
	Farmers_Market_Value -= previous_supply_worth
	Farmers_Market_Value += current_supply_worth
	
	Recent_Changes_in_Farmers_Market_Value.append(current_supply_worth - previous_supply_worth)
	print("DEMAND: " + str(Demand))
	print("PRICE: " + str(Current_Price_of_Milk))
	print("FARMERS VALUE: " + str(Farmers_Market_Value))
func _on_market_update_time_timeout() -> void:
	print()
	determine_price_of_milk()

func _on_investment_update_timeout() -> void:
	print()
	investment_in_farmers()
