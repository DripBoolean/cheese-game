class_name Cow extends Node3D

#@export var Raw_Milk_Production = 100


func _physics_process(delta):
	if randf() < 0.01 * delta:
		$AudioStreamPlayer3D.play()
		print("mooing")
