extends Control

var request = "Unknown"
var yes_outcome = "Do Nothing"
var no_outcome = "Do Nothing"
var text = "Example"
var map = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_yes_pressed():
	map.enact_request(yes_outcome)
	queue_free()


func _on_no_pressed():
	map.enact_policy(no_outcome)
	queue_free()
