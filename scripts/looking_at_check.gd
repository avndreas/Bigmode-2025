extends RayCast3D


var last_looked_at : Node
#var interact_time : float
var label : Label3D
var crit_event : CriticalEvent
var activation_item : Activator
var pickup_item : Item3D

@onready var inventory : Inventory = %Inventory

@onready var pickup_sound = $pickup_sound


@export var interact_range : float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	target_position *= interact_range
	
func set_items(obj) -> void:
	label = null
	crit_event = null
	activation_item = null
	pickup_item = null

	if not obj == null:
		if obj is Item3D:
			pickup_item = obj
			
		var parent = obj.get_parent()
		if parent:
			if parent is Activator:
				#print("activator set 1")
				activation_item = parent
			elif parent is CriticalEvent:
				crit_event = parent
			
		for child in obj.get_children():
			if child is Label3D:
				label = child
			#elif child is CriticalEvent:
				#crit_event = child
			#elif child is Activator:
				#print("activator set 2")
				#activation_item = child
			if not label == null and not crit_event == null and not activation_item == null:
				break
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_colliding():
		var colliding_obj = get_collider()
		if colliding_obj != last_looked_at:
			#resets here
			if label and is_instance_valid(label):
				label.visible = false
			if crit_event and is_instance_valid(crit_event):
				crit_event.halt_interaction()
			
			set_items(colliding_obj)

				
		#print("hi")
		if get_collision_mask_value(4) and colliding_obj != last_looked_at: # 4 is hard coded as the collision layer number for named
			#print("collide")
			if not label == null:
				label.visible = true
		
		if get_collision_mask_value(3):
			#colliding_obj
			#if Input.is_action_pressed("interact"):
				#if not crit_event == null:
					#if last_looked_at != colliding_obj:
						#interact_time = 0
					#else:
						#interact_time += delta
						#
					#if crit_event.repair_time <= interact_time:
						#crit_event.reset_timer_to_max()
						#interact_time = 0
					
			#else:
				#interact_time = 0
					
			if Input.is_action_just_pressed("interact"):
				if activation_item:
					#print("activate")
					activation_item.activate()

				#print(inventory, " ", pickup_item)
				if crit_event:
					crit_event.begin_interaction(inventory)
					
				
				if pickup_item and inventory:
					#print("hi")
					inventory.inv.add_item(pickup_item.pickup())
					inventory.refresh_inventory()
					pickup_sound.play()
					pass
					
			if Input.is_action_just_released("interact"):
				
				if crit_event:
					crit_event.halt_interaction()
				
				
	


		last_looked_at = colliding_obj
	else:
		if not label == null:
			label.visible = false
		#if not Input.is_action_pressed("interact"):
			#interact_time = 0
		last_looked_at = null
