extends Node3D

@onready var cow = $"Cow-irl"
@onready var cow2 = $"Cow-irl2"
@onready var cow3 = $"Cow-irl3"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cow.global_rotate(Vector3(0.0,1.0,0.0),cos(0.15)*delta)
	cow2.global_rotate(Vector3(0.0,0.0,1.0),sin(0.15)*delta)
	cow3.global_rotate(Vector3(1.0,0.0,0.0),cos(0.75)*delta)
