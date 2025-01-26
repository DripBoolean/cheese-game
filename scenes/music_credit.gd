extends CanvasLayer

var text_file_path = "res://assets/Sounds/Sound_Credits.txt"

@onready var label = $main_menu/Control/violet

func _ready():
	var text_content = get_text_file_content(text_file_path)
	label.text = text_content

func get_text_file_content(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	return content


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
