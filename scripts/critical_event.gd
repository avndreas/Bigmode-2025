extends Node3D
class_name CriticalEvent

@export var repair_time : float = 1
var timer : Timer
@export var crit_time : float = -1
var label : Label3D
var base_time : float = 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	label = Label3D.new()
	add_child(timer)
	add_child(label)
	base_time = crit_time if crit_time >= 0 else base_time # default 30 second crit time
	timer.wait_time = base_time
	timer.one_shot = true
	#print(crit_time if not crit_time >= 0 else 30)
	#timer.start(crit_time if crit_time >= 0 else 30)
	timer.start()
	timer.autostart = false
	UniverseSingleton.LabelSettings3D(label)
	label.visible = true
	#label.text = str(timer.time_left)
	label.position.y = 1
	#label.text = ""
	#print(get_tree().get_current_scene())
	var level = get_tree().get_current_scene()
	if level is Level:
		timer.timeout.connect(level._end_game.bind(false))
	
#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(timer.time_left)
	var pad : int = 0
	if timer.time_left < 10: #threshold for visual limits
		pad = 2
	label.text = str(timer.time_left).pad_decimals(pad)

func reset_timer_to_max() -> void:
	timer.stop()
	timer.start()
	
func stop_timer() -> void:
	timer.stop()
	
