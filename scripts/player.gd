extends CharacterBody3D


#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5

var mouse_sensitivity_y : float = 4
var mouse_sensitivity_x : float = 4
var mouse_locked : bool = false

const SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 6.0
const SENSITIVITY = 0.003

var gravity = 9.8 * 4
var speed = SPEED


func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode >= Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity_y / get_viewport().get_visible_rect().size.x)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity_x / get_viewport().get_visible_rect().size.y)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(89), deg_to_rad(89)) # has the bounds on the up and down looking



func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity = 9.8 * 2
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_released("jump"):
		gravity = 9.8 * 4
		
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 4.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 4.0)

	move_and_slide()

#
#func _process(delta:float) -> void:
	#pass
	
func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
