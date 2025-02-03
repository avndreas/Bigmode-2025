extends CharacterBody3D


#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5

@onready var dark_light: OmniLight3D = $DarkLight

#Ibrahim Audio
@onready var flashlight_audio = $flashlight_audio
@onready var footsteps_audio = $footsteps_audio
@onready var footsteps_sound1 = preload("res://assets/soundeffects/Step1.mp3")
@onready var footsteps_sound2 = preload("res://assets/soundeffects/Step2.mp3")
@onready var footsteps_sound3 = preload("res://assets/soundeffects/Step3.mp3")


var step_timer = 0.0
var walk_step_rate = 0.7  # Time between steps when walking
var sprint_step_rate = 0.45  # Time between steps when sprinting
var current_step_rate = walk_step_rate


@onready var camera : Camera3D = $Camera3D

var mouse_sensitivity_y : float = 4
var mouse_sensitivity_x : float = 4
var mouse_locked : bool = false

const SPEED = 3.0
const SPRINT_SPEED = 5.0
const JUMP_VELOCITY = 6.0
const SENSITIVITY = 0.003

var gravity = 9.8 * 4
var speed = SPEED

@export var time_left_on_flashlight : float = 20 # in seconds
var flashlight_on : bool = false
#var flashlight : SpotLight3D

@export var gloom_limit : float = 10
var gloom : bool = false
@onready var gloom_shader : ColorRect = $Shaders/Gloom


@export var life_limit : float = 10
var not_enough_life : bool = false
@onready var life_shader : ColorRect = $Shaders/Woozy

var cold : bool = false
var cold_time : float = 0
@export var max_cold_time : float = 10
@onready var cold_shader : ColorRect = $Shaders/Cold
@export var cold_speed_divisor : float = 1.5

var rng : RandomNumberGenerator

func _ready() -> void:
	var parent = get_parent()
	dark_light.visible = false
	if parent is Level:
		parent.game_state_update.connect(player_state_updater)
	rng = RandomNumberGenerator.new()
	rng.randomize()



func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode >= Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity_y / get_viewport().get_visible_rect().size.x)
		camera.rotate_x(-event.relative.y * mouse_sensitivity_x / get_viewport().get_visible_rect().size.y)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(89), deg_to_rad(89)) # has the bounds on the up and down looking

func play_random_step():
	var random_number = randi() % 3
	match random_number:
		0: footsteps_audio.stream = footsteps_sound1
		1: footsteps_audio.stream = footsteps_sound2
		2: footsteps_audio.stream = footsteps_sound3
	
	footsteps_audio.pitch_scale = randf_range(1, 1.1 )
	footsteps_audio.play()

func _physics_process(delta: float) -> void:
	
	
	
	# Check if sprinting (assuming you use Input.is_action_pressed("sprint"))
	if Input.is_action_pressed("sprint"):
		current_step_rate = sprint_step_rate
	else:
		current_step_rate = walk_step_rate
	if velocity.length() > 0.1:  # If moving
		step_timer += delta
		if step_timer >= current_step_rate:
			play_random_step()
			step_timer = 0.0





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
	
	if cold:
		speed = SPEED/cold_speed_divisor
		
	if Input.is_action_just_pressed("action1") and time_left_on_flashlight > 0:
		#print("flashlight turning")
		flashlight_audio.play()
		flashlight_on = not flashlight_on

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
func _process(delta:float) -> void:
	if time_left_on_flashlight <= 0:
		flashlight_on = false
	if flashlight_on:
		time_left_on_flashlight -= delta
		%Flashlight.visible = true
	else:
		%Flashlight.visible = false
	
	#print(gloom)
	gloom_shader.visible = gloom
	#print(not_enough_life)
	life_shader.visible = not_enough_life
	
	cold_shader.visible = cold
	if cold:
		#print("hi")
		var min_strength = 0
		var max_strength = 0.2
		var shake_strength = min((max_strength-min_strength)/(max_cold_time-cold_time), max_strength)
		camera.h_offset = rng.randf_range(-shake_strength, shake_strength)
		camera.v_offset = rng.randf_range(-shake_strength, shake_strength)
	else:
		camera.h_offset = 0
		camera.v_offset = 0

	
func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func player_state_updater(update : GameStateUpdate) -> void:
	if update.light:
		if not update.light_on:
			gloom = true
			dark_light.visible = true
			var gloom_min : float = 1.0
			var gloom_max : float = 100.0
			gloom_shader.get_material().set_shader_parameter("chaos",(gloom_max-gloom_min)/(gloom_limit-update.light_off_time))
			if update.light_off_time > gloom_limit:
					var parent = get_parent()
					if parent is Level:
						parent._end_game(false)
		else:
			gloom = false
			dark_light.visible = false

	if (update.life_support and not update.life_support_on) or (update.gas and not update.gas_on):
		#print("dying due to bad life stuff")
		not_enough_life = true
		var time_val = max(update.life_support_off_time, update.gas_off_time)
		var min_amp : float = 0.0
		var max_amp : float = 0.2
		life_shader.get_material().set_shader_parameter("amplitude",(max_amp-min_amp)/(life_limit-time_val))
		
		
		if time_val > life_limit:
				var parent = get_parent()
				if parent is Level:
					parent._end_game(false)
		# dying of life stuff here
	else:
		not_enough_life = false
		pass
		
	if update.boiler:
		#print("hi")
		cold = not update.boiler_on
