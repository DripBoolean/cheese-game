extends Node3D

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

var money: float = 500_000_000.0
var politcal_points: float = 0.0
var cheese: int = 0
@export var cheese_max: int = 100
var cave_cheese: int = 0

var cur_state = null

var verbose: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cur_state = "START"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var scorer1: bool = money >= 5_000_000.0
	var scorer2: bool = cheese/cheese_max >= 0.75
	var scorer3: bool = cave_cheese > 1
	var scorer4: bool = politcal_points >= 50.0
	var scores := [scorer1, scorer2, scorer3, scorer4]
	
	for i in range( len(scores) ):
		cur_state = state_machine.get( [ cur_state, scores[i] ] )
	if verbose:
		print(cur_state)
		verbose = false
