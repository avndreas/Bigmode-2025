extends Activator
class_name Door

@export var door_body : AnimatableBody3D = get_parent()

@export var movement_speed : float = 5
@export var pos2 : Vector3 = Vector3.UP

@onready var pos1 : Vector3 = door_body.position
@onready var current_goal_pos : Vector3 = pos1

var stop : bool = true

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
func _physics_process(delta: float) -> void:
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
	if current_goal_pos == pos1:
		#print("moving_to_pos2")
		current_goal_pos = pos2
		stop = false
	else:
		#print("moving_to_pos1")
		current_goal_pos = pos1
		stop = false
	
