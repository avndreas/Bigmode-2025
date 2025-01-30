extends RigidBody3D
class_name Item3D

@export var label_offset : Vector3 = Vector3(0,1,0)
@export var item_type : Item.Items = Item.Items.NONE

func _physics_process(_delta: float) -> void:
	$Label3D.global_position = global_position+label_offset
	if $Label3D.visible and Item.item_name_mapping.has(item_type):
		$Label3D.text = Item.item_name_mapping[item_type]


func get_item() -> Item:
	var path_name = Item.file_name_mapping[item_type]
	if path_name == null:
		print("ERROR: could not load item, no mapped pathname")
		return null
	var loaded = load(path_name)
	if !loaded:
		print("ERROR: could not load item, invalid pathname mapped")
		return null
	if not loaded is Item:
		print("ERROR: non-Item object was loaded when it should have been")
		return null
	return loaded


func pickup() -> Item:
	var path_name = Item.file_name_mapping[item_type]
	if path_name == null:
		print("ERROR: could not load item, no mapped pathname")
		return null
	var loaded = load(path_name)
	if !loaded:
		print("ERROR: could not load item, invalid pathname mapped")
		return null
	if not loaded is Item:
		print("ERROR: non-Item object was loaded when it should have been")
		return null
		
		
	var parent = get_parent()
	if parent:
		parent.remove_child(self)
		self.queue_free()
		
	return loaded
