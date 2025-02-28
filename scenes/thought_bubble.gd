extends Control

var request = "Unknown"
var yes_outcome = "Do Nothing"
var no_outcome = "Do Nothing"
var text = "Example"
var map = null
var time_remaining = 7.0

var awaiting_sound_timeout = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer3D.play()
	$Label.text = request
	if request == "farm_ask_money":
		$Label.text = "Subsidise Farms"
		yes_outcome = "give_farm_money"
	if request == "city_ask_money":
		$Label.text = "City Stipend"
		yes_outcome = "give_city_money"
	if request == "suburb_ask_money":
		$Label.text = "Single Mom Asks for Money"
		yes_outcome = "give_suburb_money"
	if request == "farm_sell_cheese":
		$Label.text = "Buy Milk From Farms"
		yes_outcome = "buy_milk"
	if request == "city_buy_cheese":
		$Label.text = "Sell Cheese to City"
		yes_outcome = "sell_cheese"
	if request == "suburb_buy_cheese":
		$Label.text = "Sell Cheese to Town"
		yes_outcome = "sell_cheese"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_remaining -= delta
	
	if time_remaining < 0:
		queue_free()
	


func _on_yes_pressed():
	$AudioStreamPlayer3D.stream = load("res://assets/Sounds/Sign_Policy(stamping).wav")
	$AudioStreamPlayer3D.play(0.0)
	map.enact_request(yes_outcome)
	awaiting_sound_timeout = true
	visible = false


func _on_no_pressed():
	map.enact_request(no_outcome)
	queue_free()


func _on_audio_stream_player_3d_finished():
	if awaiting_sound_timeout:
		queue_free()
