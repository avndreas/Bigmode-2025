extends Node3D
class_name CriticalEvent

@export var repair_time : float = 1
var timer : Timer
@export var crit_time : float = -1
var label : Label3D
var base_time : float = 30

#signal eventTriggered
signal eventState(on: bool, event: CriticalEvent)
#emit_signal("eventState", timer.time_left > 0, self)
#signal eventRestored

var interact_timer : Timer
@export var required_item : Item.Items = Item.Items.NONE
var held_inv : Inventory

var held_item : Item

@export var text_range : float = 7


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = Timer.new()
	label = Label3D.new()
	add_child(timer)
	add_child(label)
	base_time = crit_time if crit_time >= 0 else base_time # default 30 second crit time
	#print(base_time)
	timer.wait_time = base_time
	timer.one_shot = true
	#print(crit_time if not crit_time >= 0 else 30)
	#timer.start(crit_time if crit_time >= 0 else 30)
	timer.start()
	timer.autostart = false
	UniverseSingleton.LabelSettings3D(label)
	label.visible = false
	#label.text = str(timer.time_left)
	label.position.y = 1
	#label.text = ""
	#print(get_tree().get_current_scene())
	var level = get_tree().get_current_scene()
	if level is Level:
		#timer.timeout.connect(level._end_game.bind(false))
		timer.timeout.connect(timer_end)
		
		
	interact_timer = Timer.new()
	interact_timer.autostart = false
	interact_timer.one_shot = true
	interact_timer.wait_time = repair_time
	
	interact_timer.timeout.connect(finish_interaction) # set up the signal connection here
	
	add_child(interact_timer)
	
	
	var area := Area3D.new()
	#area.global_position = global_position
	var temp_collision := CollisionShape3D.new()
	var sphere_shape := SphereShape3D.new()
	sphere_shape.radius = text_range
	
	temp_collision.shape = sphere_shape
	area.add_child(temp_collision)
	area.collision_mask = 0
	area.collision_layer = 0
	area.set_collision_mask_value(1,true)
	area.body_entered.connect(set_text.bind(true))
	area.body_exited.connect(set_text.bind(false))
	add_child(area)
	label.visible = false
	
	
func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time_before = timer.time_left
	
	#print(timer.time_left)
	
	var time_added_per_second : float = 3
	
	#var num : float = timer.time_left
	#if held_item:
		#num = min(timer.time_left+(time_added_per_second*delta),base_time)
		
	if held_item:
		timer.start(min(timer.time_left+(time_added_per_second*delta),base_time))
	#
	var pad : int = 0
	if timer.time_left < 10: #threshold for visual limits
		pad = 2
	label.text = str(timer.time_left).pad_decimals(pad)
	
	if timer.time_left > 0 and time_before == 0:
		#emit_signal("eventRestored")
		emit_signal("eventState", true, self)

func reset_timer_to_max() -> void:
	timer.stop()
	timer.start()
	
func stop_timer() -> void:
	timer.stop()
	
func begin_interaction(inventory : Inventory) -> void:
	#print("beginning interaction")
	if inventory.has_item_of_type(required_item) or held_item or required_item == Item.Items.NONE:
		#print("starting interaction timer")
		interact_timer.start()
		held_inv = inventory
	#pass
	#if (item == null and required_item == Item.Items.NONE) or \
							#(item and item.type == required_item): # a null check on the item
		#interact_timer.start()
		# figure out the timer conenction stuff here to dynamincally connect and disconnect from the player initiating it or something?
		
func halt_interaction() -> void:
	#print("halting interaction")
	interact_timer.stop()
	held_inv = null
	
func finish_interaction() -> void:
	#print("finishing interaction")
	if held_item:
		held_inv.push_item(held_item)
		held_item = null
	else:
		var popped_item = held_inv.pop_item_of_type(required_item)
		#print(popped_item)
		if popped_item:
			held_item = popped_item
			
		if required_item == Item.Items.NONE:
			reset_timer_to_max()
		
		#emit_signal("eventRestored")
		
	held_inv = null

func timer_end() -> void:
	#emit_signal("eventTriggered")
	emit_signal("eventState", false, self)
	
	
func set_text(body : Node3D, on: bool):
	if body is CharacterBody3D:
		print("set_text")
		label.visible = on
	
