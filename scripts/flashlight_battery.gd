extends TextureProgressBar

@export var player : CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $"../../.."
	max_value = player.time_left_on_flashlight * 100



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = player.time_left_on_flashlight * 100
	#print(value)
	
	var percentage : float = value/float(max_value) 
	var colour : Color = Color.GREEN
	if percentage > 0.75:
		colour = Color.GREEN
	elif percentage > 0.25:
		colour = Color.YELLOW
	else:
		colour = Color.RED
	
	tint_progress = colour
