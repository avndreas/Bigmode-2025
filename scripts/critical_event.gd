extends Node3D
class_name CriticalEvent

@export var time : float = 1
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
	#print(crit_time if not crit_time >= 0 else 30)
	#timer.start(crit_time if crit_time >= 0 else 30)
	timer.start()
	timer.autostart = false
	label.visible = true
	#label.text = str(timer.time_left)
	label.position.y = 1
	label.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	#label.text = ""
	
#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(timer.time_left)
	label.text = str(timer.time_left).pad_decimals(0)

func reset_timer_to_max() -> void:
	timer.stop()
	timer.start()
