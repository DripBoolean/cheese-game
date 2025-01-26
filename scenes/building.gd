extends Node3D


@export var type = "Office1"
@export var area = "None"
var in_good_form = true
var map = null
var bubble = null



func damage():
	in_good_form = false
	if area == "city":
		if randf() < 0.05:
			$FireParticle.visible = true
	#$FireParticle.visible = true
	match type:
		"Office1":
			$Tower1.visible = false
			$"Tower1-Destroyed".visible = true
		"Office2":
			$Tower2.visible = false
			$"Tower2-Destroyed".visible = true
		"Office3":
			$Tower3.visible = false
			$"Tower3-Destroyed".visible = true
		"Office4":
			$"Final-Tower".visible = false
			$"Final-Tower-Destroyed".visible = true
		"Suburb":
			$suburb.visible = false
			$"suburb-Destroyed".visible = true

func repair():
	in_good_form = true
	$FireParticle.visible = false
	match type:
		"Office1":
			$Tower1.visible = true
			$"Tower1-Destroyed".visible = false
		"Office2":
			$Tower2.visible = true
			$"Tower2-Destroyed".visible = false
		"Office3":
			$Tower3.visible = true
			$"Tower3-Destroyed".visible = false
		"Office4":
			$"Final-Tower".visible = true
			$"Final-Tower-Destroyed".visible = false
		"Suburb":
			$suburb.visible = true
			$"suburb-Destroyed".visible = false
	

func have_thought(request_name):
	if bubble == null:
		var new_bubble = load("res://scenes/thought_bubble.tscn").instantiate()
		new_bubble.map = map
		new_bubble.request = request_name
		bubble = new_bubble
		add_child(new_bubble)

func _ready():
	$Mesh.visible = false
	$Mesh2.visible = false
	$Mesh3.visible = false
	match type:
		"Office1":
			$Tower1.visible = true
		"Office2":
			$Tower2.visible = true
		"Office3":
			$Tower3.visible = true
		"Office4":
			$"Final-Tower".visible = true
		"Suburb":
			$suburb.visible = true
		"Farm":
			$"farm-house".visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bubble != null:
		bubble.position = get_viewport().get_camera_3d().unproject_position(position)
