extends Node
class_name UniverseSingleton

#@onready var universe: Node = $"."
#@onready var timer_component: Timer = $TimerComponent

@onready var this_scene = load("res://scenes/Universe.tscn")
@onready var main_menu_scene = load("res://scenes/main_menu.tscn")
#@onready var main_menu_scene = load("res://menus/title/3DMenuScene.tscn")
@onready var level_one = load("res://scenes/test.tscn")
#@onready var credits = load("res://menus/title/Credits.tscn")
#@onready var opening_cutscene: = load("res://scenes/opening_cutscene.tscn")
@onready var tilemap_test = load("res://scenes/tilemap-test.tscn")
#@onready var current_level = -1
@onready var current_scene: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().change_scene_to_packed(opening_cutscene)
	switch_scene(1)
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (get_tree().current_scene != null):
		current_scene = get_tree().current_scene
	#print(get_tree().current_scene)
	#pass

func switch_scene(sceneNo: int) -> void:
	match sceneNo:
		#0:
			#current_level = 0
			#get_tree().change_scene_to_packed(opening_cutscene)
		1:
			#current_level = 1
			get_tree().change_scene_to_packed(main_menu_scene)
		2:
			#current_level = 2
			#get_tree().change_scene_to_packed(level_one)
			get_tree().change_scene_to_packed(tilemap_test)
		#3:
			#current_level = 3
			#get_tree().change_scene_to_packed(credits)
	pass
	
static func LabelSettings3D(label : Label3D) -> Label3D:
	label.alpha_cut = Label3D.ALPHA_CUT_DISCARD
	label.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	label.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	label.visible = false
	return label
	
#func switch_scene(scene_name : String) -> void:
	#var fullname = "res://levels/scenes/" + scene_name + ".tscn"
	#if ResourceLoader.exists(fullname, "PackedScene"):
		#get_tree().change_scene_to_packed(load(fullname))
	#else:
		#print("DEBUG: level "+scene_name+" doesn't exist at the path \"" +fullname + "\"")
