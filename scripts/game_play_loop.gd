extends Node3D
class_name Level

var game_timer : Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random = RandomNumberGenerator.new()
	var game_length = random.randfn(7, 0.7) * 60
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
