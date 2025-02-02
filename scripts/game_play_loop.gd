extends Node3D
class_name Level

@onready var lights: Node3D = $"./Lights"
@onready var player: CharacterBody3D = $"./Player"

var game_timer : Timer

var lights_on : bool = true
var lights_off_time : float = 0
var oxygen_on : bool = true
var oxygen_off_time : float = 0
var gas_on : bool = true
var gas_off_time : float = 0
var life_support_on : bool = true
var life_support_off_time : float = 0

signal game_state_update(update : GameStateUpdate)

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
	if not lights_on:
		lights_off_time += delta
		var update := GameStateUpdate.new()
		update.light = true
		update.light_off_time = lights_off_time
		update.light_on = lights_on
		emit_signal("game_state_update", update)
	else:
		lights_off_time = 0
		
	if not oxygen_on:
		oxygen_off_time += delta
		var update := GameStateUpdate.new()
		update.oxygen = true
		update.oxygen_off_time = lights_off_time
		update.oxygen_on = lights_on
		emit_signal("game_state_update", update)
	else:
		oxygen_off_time = 0
	
	if not gas_on:
		gas_off_time += delta
		var update := GameStateUpdate.new()
		update.gas = true
		update.gas_off_time = lights_off_time
		update.gas_on = lights_on
		emit_signal("game_state_update", update)
	else:
		gas_off_time = 0
	
	if not life_support_on:
		life_support_off_time += delta
		var update := GameStateUpdate.new()
		update.life_support = true
		update.life_support_off_time = lights_off_time
		update.life_support_on = lights_on
		emit_signal("game_state_update", update)
	else:
		life_support_off_time = 0

func toggleLights() -> void:
	lights_on = not lights_on
	
	var update := GameStateUpdate.new()
	update.light = true
	update.light_off_time = lights_off_time
	update.light_on = lights_on
	emit_signal("game_state_update", update)
	var rng = RandomNumberGenerator.new()
	for l in lights.get_children():
		await get_tree().create_timer(rng.randf_range(0.0, 0.1)).timeout
		l.toggleLight()

func turnOffLights() -> void:
	#print("turning lights off")
	lights_on = false
	
	var update := GameStateUpdate.new()
	update.light = true
	update.light_off_time = lights_off_time
	update.light_on = lights_on
	emit_signal("game_state_update", update)
	var rng = RandomNumberGenerator.new()
	for l in lights.get_children():
		await get_tree().create_timer(rng.randf_range(0.0, 0.1)).timeout
		l.setLightStatus(false)

func turnOnLights() -> void:
	#print("turning lights on")
	lights_on = true
	
	var update := GameStateUpdate.new()
	update.light = true
	update.light_off_time = lights_off_time
	update.light_on = lights_on
	emit_signal("game_state_update", update)
	var rng = RandomNumberGenerator.new()
	for l in lights.get_children():
		await get_tree().create_timer(rng.randf_range(0.0, 0.1)).timeout
		l.setLightStatus(true)




#func _on_generatorpanel_event_triggered(on : bool, event:CriticalEvent) -> void:
	#turnOffLights()



#func _on_generatorpanel_event_restored(on : bool, event:CriticalEvent) -> void:
	#turnOnLights()


func _on_generator_event_state(on: bool, event: CriticalEvent) -> void:
	var update := GameStateUpdate.new()
	update.crit_event = event
	emit_signal("game_state_update", update)
	
	if on:
		turnOnLights()
	else:
		turnOffLights()
		


func _on_gas_room_pipe_event_state(on: bool, event: CriticalEvent) -> void:
	var update := GameStateUpdate.new()
	update.crit_event = event
	emit_signal("game_state_update", update)
	
	if on:
		print("Gas leak contained.")
	else:
		print("Gas leaking...")


func _on_life_support_event_state(on: bool, event: CriticalEvent) -> void:
	var update := GameStateUpdate.new()
	update.crit_event = event
	emit_signal("game_state_update", update)
	
	if on:
		print("Life support online.")
	else:
		print("Oxygen lowering...")
