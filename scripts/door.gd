@tool
extends Activator
class_name Door

### a door

### SPECIAL EXPORT STUFF
#https://forum.godotengine.org/t/conditionally-show-exported-variables/43678/4

@export_category("door_movement")

@export var movement_speed : float = 5
@export var opened_pos : Vector3 = Vector3.UP
@export var opened_rot : Vector3 = Vector3.ZERO

@onready var closed_pos : Vector3 = Vector3.ZERO
#@onready var current_goal_pos : Vector3 = closed_pos
@onready var closed_rot : Vector3 = Vector3.ZERO
var currently_open : bool = false


@export_category("activation_types")
@export var area_activatable : bool = true:
		set(value):
			if value == area_activatable : return
			area_activatable = value
			notify_property_list_changed()



@export var player_activatable : bool = false:
		set(value):
			if value == player_activatable : return
			player_activatable = value
			notify_property_list_changed()

#var coll_area_shape : CollisionShape3D

var activator : Activator
@export var locked_open : bool = false


@onready var door_body : AnimatableBody3D = $AnimatableBody3D
@onready var area : Area3D = $Area3D

#@export var door_scene : PackedScene
enum INTERACTIONS_NEEDED {constant, random}
var needed : INTERACTIONS_NEEDED = INTERACTIONS_NEEDED.constant :
	set(value):
			if value == needed : return
			needed = value
			notify_property_list_changed()
			
var interaction_count_needed : int = 1
var interactions_done : int = 0
var random_interaction_range : Vector2i



@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _get_property_list():
	if Engine.is_editor_hint():
		#print( get_script().get_script_property_list() ) ## to show all the export stuff and say what needs to be set
		var ret =[]
		if area_activatable:
			pass
			#ret.append({
				#"name": "coll_area_shape", 
				#"class_name": &"CollisionShape3D", 
				#"type": 24, 
				#"hint": 34, 
				#"hint_string": "CollisionShape3D", 
				#"usage": 4102
			#})
			#ret.append({
				#"name": &"close_after_leaving",
				#"class_name": &"",
				#"type": TYPE_BOOL,
				#"hint": 0,
				#"hint_string": "",
				#"usage": 4102
			#})
		if player_activatable:
			ret.append({
				"name": "activator", 
				"class_name": &"Activator", 
				"type": 24, 
				"hint": 34, 
				"hint_string": "Activator", 
				"usage": 4102
			})
			ret.append({
				"name": "needed", 
				"class_name": &"Door.INTERACTIONS_NEEDED", 
				"type": 2, 
				"hint": 2, 
				"hint_string": "Constant:0,Random:1", 
				"usage": 69638 
			})
			if needed == INTERACTIONS_NEEDED.constant:
				ret.append({
					"name": &"interaction_count_needed",
					"type": TYPE_INT,
					"usage": PROPERTY_USAGE_DEFAULT,
				})
			elif needed == INTERACTIONS_NEEDED.random:
				ret.append({
					"name": &"random_interaction_range", 
					"class_name": &"", 
					"type": TYPE_VECTOR2I, 
					"hint": 0, 
					"hint_string": "", 
					"usage": 4102
				})
			
		return ret





var stop : bool = true

## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	door_body.collision_layer = 0
	door_body.set_collision_layer_value(2,true)
	door_body.set_collision_layer_value(3,true)
	
	if area_activatable:
		area.collision_mask = 0
		area.set_collision_mask_value(1,true)
	#

	if !activator:
		activator = self
		
	if activator.has_method("set_activatee"):
		activator.set_activatee(self)
		
	if interaction_count_needed < 1:
		interaction_count_needed = 1
		
	if needed == INTERACTIONS_NEEDED.random:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		if random_interaction_range.x > random_interaction_range.y:
			var temp = random_interaction_range.y
			random_interaction_range.y = random_interaction_range.x
			random_interaction_range.x = temp
		interaction_count_needed = rng.randi_range(random_interaction_range.x, random_interaction_range.y)

	#var anim := Animation.new()
	#anim.add_track(Animation.TYPE_POSITION_3D)
	#
	#
	#
	#
	#
	#var anim_player := AnimationPlayer.new()
	#var anim_library := AnimationLibrary.new()
	#anim_library.add_animation("door_movement", anim)
	#anim_player.add_animation_library("lib", anim_library)
	#
	



## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
#func _physics_process(delta: float) -> void:
	##print("hi2")
	#if door_body == null:
		##print("ddasdasd")
		#for child in get_children():
			##print("child")
			#if child is AnimatableBody3D:
				#door_body = child
				#closed_pos = door_body.position
				##print("hi1")
				#break
		#return
		#
	#if door_body.position != current_goal_pos and not stop:
		##print("door_moving")
		#var move_dir : Vector3 = (current_goal_pos - door_body.position).normalized()
		#var dist : float = current_goal_pos.distance_to(door_body.position)
		#var movement_vector : Vector3 = movement_speed * delta * move_dir
		#if movement_vector.length() > dist:
			#movement_vector = movement_vector.normalized() * dist
			##print("hwody")
		##var collision : KinematicCollision3D = door_body.move_and_collide(movement_vector)
		#door_body.constant_linear_velocity = movement_vector
		##if not collision == null:
			###print("collide")
			###print(deg_to_rad(collision.get_angle()))
			###print(collision.get_normal())
			###print(movement_vector.normalized())
			##print((-collision.get_normal()).angle_to(movement_vector.normalized()))
			##print(collision.get_angle(0,movement_vector))
			##if (-collision.get_normal()).angle_to(movement_vector.normalized()) < deg_to_rad(89) and \
			##collision.get_angle(0,movement_vector) < deg_to_rad(89):
				###print("hi")
			###if collision.get_normal() == -movement_vector.normalized():
				##stop = true
				##print("stopped due to collision")

func activate() -> void:
	if player_activatable:
		interactions_done += 1
		#print("hi ",interactions_done)
		
		if interaction_count_needed > interactions_done:
			return
		#print("hi")
		if currently_open:
			close()
		else:
			#print("opening")
			open()
		
func close(body : Node3D = null) -> void:
	#print("close")
	if (body == null or (body is CharacterBody3D and area_activatable)) and !locked_open:
		#current_goal_pos = closed_pos
		#stop = false
		#print(anim_player)
		anim_player.play_backwards("new_animation")
		currently_open = false
	
func open(body : Node3D = null) -> void:
	#print("open")
	if body == null or (body is CharacterBody3D and area_activatable):
		#current_goal_pos = opened_pos
		#stop = false
		#print(anim_player)
		anim_player.play("new_animation")
		currently_open = true
	
