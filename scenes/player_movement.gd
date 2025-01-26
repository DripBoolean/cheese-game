extends CharacterBody3D

var money = 1000
var peepee = 50
var time_till_next_election = 60.0

var dairy_market_health = 1.0
var dairy_market_demand = 0.0
var poor_health = 1.0
var wealthy_health = 1.0

const SPEED = 5.0
const SCROLL_SPEED = 1.0
@onready var camera_ref = $Camera3D

func enact_request(policy_name):
	if policy_name == "Do Nothing":
		return
	
func _process(delta):
	time_till_next_election -= delta
	
	poor_health +=  (dairy_market_health - 1) * 0.01 * delta
	
	wealthy_health += (dairy_market_health - 1) * 0.05 * delta
	
	dairy_market_health -= delta * 0.05
	
	#dairy_market_health -= delta * 0.01
	
	
	$UI/Stats.text = "Money: %d   PP: %d   Time: %f    poor: %f    wealthy %f    dairy %f" % [money, peepee, time_till_next_election, poor_health, wealthy_health, dairy_market_health]

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
		move_and_collide(-camera_ref.global_basis.z * SCROLL_SPEED)
	if Input.is_action_just_pressed("zoom_out"):
		move_and_collide(camera_ref.global_basis.z * SCROLL_SPEED)

	move_and_slide()
