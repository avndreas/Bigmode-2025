extends RigidBody3D
class_name Item3D

@export var label_offset : Vector3 = Vector3(0,1,0)

func _physics_process(delta: float) -> void:
	$Label3D.global_position = global_position+label_offset


func get_item() -> Item:
	return load("res://assets/pipe.tres")
