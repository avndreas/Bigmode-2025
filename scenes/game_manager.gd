extends Node3D

@onready var lights: Node3D = $"../Lights"
@onready var player: CharacterBody3D = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action2"):
		toggleLights()

func toggleLights() -> void:
	var rng = RandomNumberGenerator.new()
	for l in lights.get_children():
		await get_tree().create_timer(rng.randf_range(0.0, 0.1)).timeout
		l.toggleLight()
