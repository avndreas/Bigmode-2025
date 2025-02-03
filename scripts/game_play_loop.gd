extends Node3D
class_name Level

@onready var lights: Node3D = $"./Lights"
@onready var player: CharacterBody3D = $"./Player"

var game_timer : Timer

var lights_on : bool = true
var lights_off_time : float = 0
var gas_on : bool = true
var gas_off_time : float = 0
var life_support_on : bool = true
var life_support_off_time : float = 0
var boiler_on : bool = true
var boiler_off_time : float = 0

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
		
	var send : bool = false
	var update := GameStateUpdate.new()
	
	
	if not lights_on:
		lights_off_time += delta
		update.light = true
		update.light_off_time = lights_off_time
		update.light_on = lights_on
		#emit_signal("game_state_update", update)
		#send = send or true
	else:
		lights_off_time = 0
	
	if not gas_on:
		gas_off_time += delta
		update.gas = true
		update.gas_off_time = gas_off_time
		update.gas_on = gas_on
		#send = send or true
		#emit_signal("game_state_update", update)
	else:
		gas_off_time = 0
	
	if not boiler_on:
		boiler_off_time += delta
		update.boiler = true
		update.boiler_off_time = boiler_off_time
		update.boiler_on = boiler_on
		#send = send or true
	else:
		boiler_off_time = 0
	
	if not life_support_on:
		life_support_off_time += delta
		update.life_support = true
		update.life_support_off_time = life_support_off_time
		update.life_support_on = life_support_on
		#send = send or true
	else:
		life_support_off_time = 0
		
	#if send:
	emit_signal("game_state_update", update)

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
	
	gas_on = on
	if on:
		gas_off_time = 0
		
		update = GameStateUpdate.new()
		update.gas = true
		update.gas_off_time = gas_off_time
		update.gas_on = gas_on
		emit_signal("game_state_update", update)
		
		print("Gas leak contained.")
	else:
		print("Gas leaking...")


func _on_life_support_event_state(on: bool, event: CriticalEvent) -> void:
	var update := GameStateUpdate.new()
	update.crit_event = event
	emit_signal("game_state_update", update)
	
	life_support_on = on
	if on:
		life_support_off_time = 0
		
		update = GameStateUpdate.new()
		update.life_support = true
		update.life_support_off_time = life_support_off_time
		update.life_support_on = life_support_on
		emit_signal("game_state_update", update)
		
		print("Life support online.")
	else:
		print("Life support offline...")


func _on_boiler_panel_event_state(on: bool, event: CriticalEvent) -> void:
	var update := GameStateUpdate.new()
	update.crit_event = event
	emit_signal("game_state_update", update)
	
	boiler_on = on
	if on:
		boiler_off_time = 0
		
		update = GameStateUpdate.new()
		update.boiler = true
		update.boiler_off_time = boiler_off_time
		update.boiler_on = boiler_on
		emit_signal("game_state_update", update)
		
		print("Boiler functional.")
	else:
		print("Boiler offline...")
