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

# FOR MONEY, POLITCAL POINTS, AND CHEESE VARIABLES
var map

var cur_state = null

var verbose: bool = false

# RANDOM EVENT VARIABLES
var random_event_wait_ticks: float = 0.0
var event_enum := {"mad":0.0, "lactose":0.0, "mania":0.0, "socialist":0.0, "facebook":0.0,
"exodus":0.0, "enter":0.0, "crime":0.0}

# TEST VARIABLES THAT WILL BE EXPORTED LATER
var demand: float = 0.99
var panic: float = 0.1
var mania: bool = false
var lactose: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cur_state = "START"

func _random_events( weight_array ) -> String:
	print("ejvaiwiehvawiei")
	var events := ["mad","lactose","mania","socialist","facebook","exodus","enterance","crime"]
	var random := RandomNumberGenerator.new()
	if randf() < 0.25:
		return events[random.rand_weighted(weight_array)]
	else:
		return "null"

func update() -> void:
	var scorer1: bool = map.money >= 500_000.0
	var scorer2: bool = map.cheese >= 50_000.0
	var scorer3: bool = map.city_health >= 50.0
	var scorer4: bool = map.political_points >= 50.0
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
			r_event = _random_events([1,1+int(lactose),1+int(mania),2,2.1,2.1,2,2])
		"P_underE": # BAD P, GOOD M, HIGH CHEESE, LOW CAVE (UNCOMMON)
			fAM_range = 0.35
			fSC_range = 0.95
			cBC_range = 0.8
			cAM_range = 0.6
			sBC_range = 0.7
			sAM_range = 0.44
			r_event = _random_events([1,1+int(lactose),1+int(mania),2,2.1,2.1,2,2])
		"P_overF": # BAD POLITICS, GOOD MONEY, LOW CHEESE, HIGH CAVE CHEESE (RARE)
			fAM_range = 0.7
			fSC_range = 0.7
			cBC_range = 0.5
			cAM_range = 0.5
			sBC_range = 0.2
			sAM_range = 0.4
			r_event = _random_events([1,1+int(lactose),1+int(mania),2,2.1,2.1,2,2])
		"P_underF": # GAME START
			fAM_range = 0.75
			fSC_range = 0.9
			cBC_range = 0.9
			cAM_range = 0.2
			sBC_range = 0.6
			sAM_range = 0.1
			r_event = _random_events([1,1+int(lactose),1+int(mania),2,2.1,2.1,2,2])
		"P_overG": # BAD P, BAD M, HIGH CH, HIGH CA
			fAM_range = 0.9
			fSC_range = 0.9
			cBC_range = 0.2
			cAM_range = 0.9
			sBC_range = 0.1
			sAM_range = 0.8
			r_event = _random_events([1,1+int(lactose),1+int(mania),2,2.1,2.1,2,2])
		"P_underG": # BAD P, BAD M, HIGH CH, LOW CA
			fAM_range = 0.8
			fSC_range = 0.9
			cBC_range = 0.4
			cAM_range = 0.5
			sBC_range = 0.4
			sAM_range = 0.25
			r_event = _random_events([1,1+int(lactose),1+int(mania),2,2.1,2.1,2,2])
		"P_overH": # BAD P, BAD M, LOW CH, HIGH CA
			fAM_range = 0.5
			fSC_range = 0.9
			cBC_range = 0.6
			cAM_range = 0.5
			sBC_range = 0.6
			sAM_range = 0.15
			r_event = _random_events([1,1+int(lactose),1+int(mania),2,2.1,2.1,2,2])
		"P_underH": # BAD P, BAD M, LOW CH, LOW CA
			fAM_range = 0.2
			fSC_range = 0.99
			cBC_range = 0.95
			cAM_range = 0.1
			sBC_range = 0.9
			sAM_range = 0.1
			r_event = _random_events([1,1+int(lactose),1+int(mania),2,2.1,2.1,2,2])
			
	fAskMoney = randf() < ( fAM_range + panic )
	fSellCheese = randf() < fSC_range
	cBuyCheese = randf() < ( ( cBC_range - (cBC_range * ( 1 - demand) ) ) - event_enum["lactose"] + event_enum["mania"] )
	cAskMoney = randf() < ( cAM_range + event_enum["socialist"] )
	sBuyCheese = randf() < ( ( sBC_range - (sBC_range * ( 1 - demand) ) ) - event_enum["lactose"] + event_enum["mania"] )
	sAskMoney = randf() < ( sAM_range + event_enum["facebook"] )
	
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
		
	# RANDOM EVENTS +++++++++++++++++++++
	if random_event_wait_ticks <= 0.0:
		#print("START")
		event_enum = {"mad":0.0, "lactose":0.0, "mania":0.0, "socialist":0.0, 
		"facebook":0.0, "exodus":0.0, "enter":0.0, "crime":0.0}
		if r_event != "null":
			print("-- EVENT: %s" % r_event)
			#print(r_event)
			event_enum[r_event] = 0.4
			if r_event == "crime":
				map.next_news_label_text = "BREAKING NEWS: UNPRECIDENTED UPTICK IN CRIME"
				map.city_health -= 25
			elif r_event == "mad":
				map.next_news_label_text = "BREAKING NEWS: MAD COW DISEASE INFLICTS FARMS"
				global.The_Farmers.Panic += 75
			elif r_event == "exodus":
				map.next_news_label_text = "UNSUPRISING NEWS: EVERYONE IS LEAVING THE CITY"
				map.tax_income -= 10_000.0
			elif r_event == "enterance":
				map.next_news_label_text = "SHOCKING NEWS: PEOPLE ARE COMMING INTO THE CITY..?"
				map.tax_income += 20_000.0
		random_event_wait_ticks = 0.0
	else:
		random_event_wait_ticks = random_event_wait_ticks - 1.0
	# +++++++++++++++++++++++++++++++++++++
	
	if verbose:
		print(cur_state)
		print(1.0 + int(true))
		print([fAskMoney,fSellCheese,cBuyCheese,cAskMoney,sBuyCheese,sAskMoney])
		verbose = false
	
	
