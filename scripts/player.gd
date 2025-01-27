extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var mouse_sensitivity_y : float = 6
var mouse_sensitivity_x : float = 6
var mouse_locked : bool = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_locked = true

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode >= Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity_y / get_viewport().size.x)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity_x / get_viewport().size.y)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(89), deg_to_rad(89)) # has the bounds on the up and down looking

		
	if event.is_action_released("escape"):
		if mouse_locked:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			mouse_locked = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			mouse_locked = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

#
#func _process(delta:float) -> void:
	#pass
	
func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
