extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$main_menu/RichTextLabel2.text = "You Survived %d Terms" % global.terms_survived
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
