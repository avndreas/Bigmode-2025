extends Activator
class_name Door

@export var door_body : AnimatableBody3D

@export var movement_speed : float = 5
@export var opened_pos : Vector3 = Vector3.UP

@onready var closed_pos : Vector3 = Vector3.ZERO
@onready var current_goal_pos : Vector3 = closed_pos

var stop : bool = true

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#if not door_body == null:
		#for child in get_children():
			#print("child")
			#if child is AnimatableBody3D:
				#door_body = child
				##print("hi1")
				#break


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
func _physics_process(delta: float) -> void:
	#print("hi2")
	if door_body == null:
		#print("ddasdasd")
		for child in get_children():
			#print("child")
			if child is AnimatableBody3D:
				door_body = child
				closed_pos = door_body.position
				#print("hi1")
				break
		return
		
	if door_body.position != current_goal_pos and not stop:
		#print("door_moving")
		var move_dir : Vector3 = (current_goal_pos - door_body.position).normalized()
		var dist : float = current_goal_pos.distance_to(door_body.position)
		var movement_vector : Vector3 = movement_speed * delta * move_dir
		if movement_vector.length() > dist:
			movement_vector = movement_vector.normalized() * dist
		var collision : KinematicCollision3D = door_body.move_and_collide(movement_vector)
		if not collision == null:
			stop = true
			#print("stopped due to collision")

func activate() -> void:
	#print("hi")
	if current_goal_pos == opened_pos:
		#print("moving_to_pos2")
		current_goal_pos = closed_pos
		stop = false
	else:
		#print("moving_to_pos1")
		current_goal_pos = opened_pos
		stop = false
		
func close(body : Node3D = null) -> void:
	#print("close")
	if body == null or body is CharacterBody3D:
		current_goal_pos = closed_pos
		stop = false
	
func open(body : Node3D = null) -> void:
	#print("open")
	if body == null or body is CharacterBody3D:
		current_goal_pos = opened_pos
		stop = false
	
