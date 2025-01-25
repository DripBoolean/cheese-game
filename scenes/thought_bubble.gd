extends Control


var yes_policy = "Do Nothing"
var no_policy = "Do Nothing"
var text = "Example"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("added")
	$Label.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
