extends Control

#@onready var play: Button = %Play
#@onready var options: Button = %Options
#@onready var credits: Button = %Credits
#@onready var quit: Button = %Quit

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#pass


func _on_play_pressed() -> void:
	#await get_tree().create_timer(20).timeout
	#print("Pressed play")
	Universe.switch_scene(2)
	pass


func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_credits_pressed() -> void:
	Universe.switch_scene(3)
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()
