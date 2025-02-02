extends Resource
class_name Item

enum Items {NONE, PIPE, FUSE}

static var file_name_mapping : Dictionary = {Items.PIPE : "res://assets/resources/pipe.tres", Items.FUSE : "res://assets/resources/fuse.tres"}
static var item_name_mapping : Dictionary = {Items.PIPE : "Pipe", Items.FUSE : "Fuse"}

@export var name : String
@export var UI_sprite : Texture2D
@export var node_for_3D : PackedScene
@export_multiline var description : String

@export var type : Items


func get_info() -> Dictionary:
	return {}
