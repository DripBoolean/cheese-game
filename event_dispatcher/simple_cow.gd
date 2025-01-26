extends Node3D

@onready var cow = $"Cow-irl2"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cow.global_rotate(Vector3(0.0,1.0,0.0),0.75*delta)
