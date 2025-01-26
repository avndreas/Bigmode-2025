extends RayCast3D


var last_looked_at : Node
var interact_time : float
var time_check : float

var range : float = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	target_position *= range

func set_label(obj, on : bool):
	if not obj == null:
		for child in obj.get_children():
			if child is Label3D or child is Label:
				child.visible = on

func check_interact_time(obj, cur_time : float):
	if not obj == null:
		for child in obj.get_children():
			if child is CriticalEvent:
				print(cur_time)
				if child.time <= cur_time:
					#print("good")
					child.reset_timer_to_max()
					#set_label(child, true)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		var colliding_obj = get_collider()
		if colliding_obj != last_looked_at:
			set_label(last_looked_at, false)
				
				
		#print("hi")
		if get_collision_mask_value(4): # 4 is hard coded as the collision layer number for named
			#print("collide")
			set_label(colliding_obj, true)
		
		if get_collision_mask_value(3):
			#colliding_obj
			if Input.is_action_pressed("interact"):
				if last_looked_at != colliding_obj:
					interact_time = 0
				else:
					interact_time += delta
					
				check_interact_time(colliding_obj, interact_time)
			else:
				interact_time = 0
					
		
				
				
	


		last_looked_at = colliding_obj
	else:
		set_label(last_looked_at, false)
		#if not Input.is_action_pressed("interact"):
			#interact_time = 0
		last_looked_at = null
