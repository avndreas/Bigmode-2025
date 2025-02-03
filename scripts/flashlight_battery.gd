extends Control

@export var player : CharacterBody3D

# Called when the node enters the scene tree for the first time.
var max_value : float
var current_value : float
@export var num_ticks : int = 5

func _ready() -> void:
	player = $"../.."
	max_value = player.time_left_on_flashlight * 100
	current_value = max_value
	var node : Control
	var offset = 20
	
	if rotation_degrees == 90:
		for child in get_children():
			#print("hi")
			#var node : TextureRect = child
			var ratio :float = child.size.x / float(child.size.y)
			child.size.y = (get_viewport().get_visible_rect().size.y * 1/10)
			child.size.x = ratio * child.size.y
		
		
		position.x = get_viewport().get_visible_rect().size.x - offset
		position.y = offset
	else:
		var outer : TextureRect = get_child(num_ticks)
		var ratio : float = outer.size.x / float(outer.size.y)
		
		for child in get_children():
			child.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			#print("hi")
			#var node : TextureRect = child
			child.size.y = (get_viewport().get_visible_rect().size.y * 1/6)
			child.size.x = ratio * child.size.y
		
		outer = get_child(num_ticks)
		
		position.x = get_viewport().get_visible_rect().size.x - (offset + outer.size.x)
		position.y = offset
#
#
#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var value = player.time_left_on_flashlight * 100
	#print(value)
	
	var percentage : float = (value*100.0)/float(max_value)
	
	var temp :float = 100.0/num_ticks
	
	for i in range(num_ticks-1,-1,-1):
		if percentage <= temp * i:
			#print(temp*i, " ", percentage)
			get_node(str(i+1)).visible = false
		else:
			break
		#print(i)
