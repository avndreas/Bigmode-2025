extends Activator
class_name ButtonActivator


## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

@export var activatee : Activator :
	set(value):
		activatee = value

func activate() -> void:
	if activatee:
		activatee.activate()
