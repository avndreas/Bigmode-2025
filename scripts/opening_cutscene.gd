extends Node3D

@onready var camera_3d: Camera3D = $Camera3D
@onready var timer: Timer = $Timer
@onready var rock_barrier: RigidBody3D = $RockBarrier
@onready var light_2: Node3D = $light2
@onready var cover_rock: RigidBody3D = $Rocks/COVER_ROCK
@onready var cover: MeshInstance3D = $Cover
@onready var opening_audio = $OpeningAudio


var rocksFalling: bool = false
var coverRock: bool = false

@export var randomStrength: float = 0.3
@export var shakeFade: float = 3.0

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	opening_audio.play()
	cover.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_3d.position.z -= delta / 2.0
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		camera_3d.h_offset = randomOffset()
		camera_3d.v_offset = randomOffset()
	
	if rocksFalling:
		rock_barrier.position.y -= delta * 8.0
	
	if Input.is_action_pressed("jump") or Input.is_action_pressed("action1"):
		Universe.switch_scene(1)


func _on_timer_timeout() -> void:
	Universe.switch_scene(1)


func _on_timer_2_timeout() -> void:
	shake_camera()
	for i in range(1, 10):
		light_2.toggleLight()
		await get_tree().create_timer(rng.randf_range(0.02, 0.3)).timeout
	light_2.setLightStatus(true)
	await get_tree().create_timer(3.0).timeout
	shakeFade = 0.2
	shake_camera()
	move_rocks()
	
	light_2.setLightStatus(false)
	await get_tree().create_timer(5.5).timeout
	move_cover_rock()

func shake_camera() -> void:
	shake_strength = randomStrength

func randomOffset() -> float:
	return rng.randf_range(-shake_strength, shake_strength)

func move_rocks() -> void:
	rocksFalling = true

func move_cover_rock() -> void:
	cover_rock.set_freeze_enabled(false)
	await get_tree().create_timer(2.0).timeout
	cover.visible = true
	
