extends Control


func _ready() -> void:
	$AnimationPlayer.play("RESET")

func resume():
	print("resuming")
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	Universe.in_game = true
	visible = false
	
func pause():
	print("pausing")
	get_tree().paused = true
	Universe.in_game = false
	visible = true
	$AnimationPlayer.play("blur")
	
	
func testEsc():
	if Input.is_action_just_pressed("escape") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused:
		#print("hi1")
		resume()
		

	
func _on_resume_pressed() -> void:
	print("hi")
	resume()

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
	
func _process(delta: float) -> void:
	testEsc()
