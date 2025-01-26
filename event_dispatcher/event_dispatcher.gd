extends Node

@export_enum("START","Money_over","Money_under","Cheese_overA","Cheese_overB") var states: String

var state_machine := { ["START", true] : "Money_over", ["START", false] : "Money_under",
["Money_over", true] : "Cheese_overA", ["Money_over", false] : "Cheese_underA",
["Money_under", true] : "Cheese_overB", ["Money_under", false] : "Cheese_underB",
["Cheese_overA", true] : "Cave_overA", ["Cheese_overA", false] : "Cave_underA",
["Cheese_underA", true] : "Cave_overB", ["Cheese_underA", false] : "Cave_underB",
["Cheese_overB", true] : "Cave_overC", ["Cheese_overB", false] : "Cave_underC",
["Cheese_underB", true] : "Cave_overD", ["Cheese_underB", false] : "Cave_underD",
["Cave_overA", true] : "P_overA", ["Cave_overA", false] : "P_underA",
["Cave_underA", true] : "P_overB", ["Cave_underA", false] : "P_underB",
["Cave_overB", true] : "P_overC", ["Cave_overB", false] : "P_underC",
["Cave_underB", true] : "P_overD", ["Cave_underB", false] : "P_underD",
["Cave_overC", true] : "P_overE", ["Cave_overC", false] : "P_underE",
["Cave_underC", true] : "P_overF", ["Cave_underC", false] : "P_underF",
["Cave_overD", true] : "P_overG", ["Cave_overD", false] : "P_underG",
["Cave_underD", true] : "P_overH", ["Cave_underD", false] : "P_underH",} 

var money: float = 50_000_000.0
var politcal_points: float = 0.0
var cheese: int = 0
@export var cheese_max: int = 100
var cave_cheese: int = 0

var cur_state = null

var verbose: bool = true


# TEST VARIABLES THAT WILL BE EXPORTED LATER
var demand: float = 0.99
var panic: float = 0.1
var mania: bool = false
var lactose: bool = false
var map

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cur_state = "START"

func _random_events( weight_array ) -> String:
	
	var events := ["mad","lactose","mania","socialist","facebook","exodus","enterance","crime"]
	var random := RandomNumberGenerator.new()
	if randf() < 0.1:
		return events[random.rand_weighted(weight_array)]
	else:
		return "null"


func update() -> void:
	var scorer1: bool = money >= 5_000_000.0
	var scorer2: bool = cheese/cheese_max >= 0.75
	var scorer3: bool = cave_cheese > 1
	var scorer4: bool = politcal_points >= 50.0
	var scores := [scorer4, scorer1, scorer2, scorer3]
	
	var r_event: String = "null"
	
	var fAskMoney: bool = false
	var fSellCheese: bool = false
	var cBuyCheese: bool = false
	var cAskMoney: bool = false
	var sBuyCheese: bool = false
	var sAskMoney: bool = false
	
	var fAM_range: float = 0.0
	var fSC_range: float = 0.0
	var cBC_range: float = 0.0
	var cAM_range: float = 0.0
	var sBC_range: float = 0.0
	var sAM_range: float = 0.0
	
	# BUG FIX: MUST RESTART MACHINE
	cur_state = "START"
	
	for i in range( len(scores) ):
		cur_state = state_machine.get( [ cur_state, scores[i] ] )
		
	match cur_state:
		"P_overA": # GOOD P, GOOD M, HIGH CH, HIGH CA
			fAM_range = 0.8
			fSC_range = 0.8
			cBC_range = 0.2
			cAM_range = 0.8
			sBC_range = 0.1
			sAM_range = 0.5
			r_event = _random_events([1,1+int(lactose),1+int(mania),0.5,0.3,1,1,0.2])
		"P_underA": # GOOD P, GOOD M, HIGH CH, LOW CA
			fAM_range = 0.6
			fSC_range = 0.9
			cBC_range = 0.3
			cAM_range = 0.6
			sBC_range = 0.1
			sAM_range = 0.45
			r_event = _random_events([1,1.1+int(lactose),1+int(mania),0.5,0.3,1,1,0.2])
		"P_overB": # GOOD P, GOOD M, LOW CH, HIGH CA
			fAM_range = 0.75
			fSC_range = 0.95
			cBC_range = 0.9
			cAM_range = 0.01
			sBC_range = 0.5
			sAM_range = 0.01
			r_event = _random_events([1,1.1+int(lactose),1+int(mania),0.5,0.3,1,1,0.2])
		"P_underB": # GOOD P, GOOD M, LOW CH, LOW CA
			fAM_range = 0.9
			fSC_range = 0.95
			cBC_range = 0.8
			cAM_range = 0.8
			sBC_range = 0.5
			sAM_range = 0.5
			r_event = _random_events([1,1+int(lactose),1+int(mania),0.5,0.3,1,1,0.2])
		"P_overC": # GOOD P, BAD M, HIGH CH, HIGH CA
			fAM_range = 0.7
			fSC_range = 0.8
			cBC_range = 0.2
			cAM_range = 0.7
			sBC_range = 0.1
			sAM_range = 0.5
			r_event = _random_events([1,1+int(lactose),1+int(mania),0.5,0.3,1,1,0.2])
		"P_underC": # GOOD P, BAD M, HIGH CH, LOW CA
			fAM_range = 0.15
			fSC_range = 0.5
			cBC_range = 0.9
			cAM_range = 0.1
			sBC_range = 0.9
			sAM_range = 0.01
			r_event = _random_events([1,1+int(lactose),1+int(mania),0.5,0.3,1,1,0.2])
		"P_overD": # GOOD P, BAD M, LOW CH, HIGH CA
			fAM_range = 0.3
			fSC_range = 0.3
			cBC_range = 0.9
			cAM_range = 0.5
			sBC_range = 0.9
			sAM_range = 0.5
			r_event = _random_events([1,1+int(lactose),1+int(mania),0.5,0.3,1,1,0.2])
		"P_underD": # GOOD P, BAD M, LOW CH, LOW CA
			fAM_range = 0.4
			fSC_range = 0.5
			cBC_range = 0.9
			cAM_range = 0.6
			sBC_range = 0.8
			sAM_range = 0.3
			r_event = _random_events([1,1+int(lactose),1+int(mania),0.5,0.3,1,1,0.2])
		"P_overE": # BAD P, GOOD M, HIGH CH, HIGH CA (COMMON)
			fAM_range = 0.95
			fSC_range = 0.95
			cBC_range = 0.3
			cAM_range = 0.9
			sBC_range = 0.1
			sAM_range = 0.8
		"P_underE": # BAD P, GOOD M, HIGH CHEESE, LOW CAVE (UNCOMMON)
			fAM_range = 0.35
			fSC_range = 0.95
			cBC_range = 0.8
			cAM_range = 0.6
			sBC_range = 0.7
			sAM_range = 0.44
		"P_overF": # BAD POLITICS, GOOD MONEY, LOW CHEESE, HIGH CAVE CHEESE (RARE)
			fAM_range = 0.7
			fSC_range = 0.7
			cBC_range = 0.5
			cAM_range = 0.5
			sBC_range = 0.2
			sAM_range = 0.4
		"P_underF": # GAME START
			fAM_range = 0.75
			fSC_range = 0.9
			cBC_range = 0.9
			cAM_range = 0.2
			sBC_range = 0.6
			sAM_range = 0.1
		"P_overG": # BAD P, BAD M, HIGH CH, HIGH CA
			fAM_range = 0.9
			fSC_range = 0.9
			cBC_range = 0.2
			cAM_range = 0.9
			sBC_range = 0.1
			sAM_range = 0.8
		"P_underG": # BAD P, BAD M, HIGH CH, LOW CA
			fAM_range = 0.8
			fSC_range = 0.9
			cBC_range = 0.4
			cAM_range = 0.5
			sBC_range = 0.4
			sAM_range = 0.25
		"P_overH": # BAD P, BAD M, LOW CH, HIGH CA
			fAM_range = 0.5
			fSC_range = 0.9
			cBC_range = 0.6
			cAM_range = 0.5
			sBC_range = 0.6
			sAM_range = 0.15
		"P_underH": # BAD P, BAD M, LOW CH, LOW CA
			fAM_range = 0.2
			fSC_range = 0.99
			cBC_range = 0.95
			cAM_range = 0.1
			sBC_range = 0.9
			sAM_range = 0.1
	
	
	fAskMoney = randf() < fAM_range + panic
	fSellCheese = randf() < fSC_range
	cBuyCheese = randf() < ( cBC_range - (cBC_range * ( 1 - demand) ) )
	cAskMoney = randf() < cAM_range
	sBuyCheese = randf() < ( sBC_range - (sBC_range * ( 1 - demand) ) )
	sAskMoney = randf() < sAM_range
	
	if fAskMoney:
		map.spawn_bubble("farm", "farm_ask_money")
	if cAskMoney:
		map.spawn_bubble("city", "city_ask_money")
	if sAskMoney:
		map.spawn_bubble("suburb", "suburb_ask_money")
	if fSellCheese:
		map.spawn_bubble("farm", "farm_sell_cheese")
	if cBuyCheese:
		map.spawn_bubble("city", "city_buy_cheese")
	if sBuyCheese:
		map.spawn_bubble("suburb", "suburb_buy_cheese")
	
	if verbose:
		print(cur_state)
		print(1.0 + int(true))
		print([fAskMoney,fSellCheese,cBuyCheese,cAskMoney,sBuyCheese,sAskMoney])
		verbose = false
	
	
