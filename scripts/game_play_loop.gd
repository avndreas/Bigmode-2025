extends Node3D
class_name Level

@onready var lights: Node3D = $"./Lights"
@onready var player: CharacterBody3D = $"./Player"

var game_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random = RandomNumberGenerator.new()
	random.randomize()
	var game_length = random.randfn(5, 0.7) * 60
	game_timer = Timer.new()
	add_child(game_timer)
	#print(game_length)
	game_timer.wait_time = game_length
	#game_timer.wait_time = 8
	game_timer.one_shot = true
	game_timer.autostart = false
	game_timer.start()
	game_timer.timeout.connect(self._end_game.bind(true))
	
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _end_game(won : bool) -> void:
	print("game_end: ", won)
	get_tree().call_group("CriticalEvents", "stop_timer")
	#CriticalEvents
	Universe.switch_scene(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action2"):
		toggleLights()

func toggleLights() -> void:
	var rng = RandomNumberGenerator.new()
	for l in lights.get_children():
		await get_tree().create_timer(rng.randf_range(0.0, 0.1)).timeout
		l.toggleLight()

func turnOffLights() -> void:
	var rng = RandomNumberGenerator.new()
	for l in lights.get_children():
		await get_tree().create_timer(rng.randf_range(0.0, 0.1)).timeout
		l.setLightStatus(false)

func turnOnLights() -> void:
	var rng = RandomNumberGenerator.new()
	for l in lights.get_children():
		await get_tree().create_timer(rng.randf_range(0.0, 0.1)).timeout
		l.setLightStatus(true)


func _on_generatorpanel_event_triggered() -> void:
	turnOffLights()


func _on_generatorpanel_event_restored() -> void:
	turnOnLights()
