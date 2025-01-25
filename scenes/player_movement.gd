extends CharacterBody3D


const SPEED = 5.0
const SCROLL_SPEED = 1.0
@onready var camera_ref = $Camera3D


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	#scrolling
	if Input.is_action_just_pressed("zoom_in"):
		global_position += -camera_ref.global_basis.z * SCROLL_SPEED
	if Input.is_action_just_pressed("zoom_out"):
		global_position += camera_ref.global_basis.z * SCROLL_SPEED
	

	move_and_slide()
