extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var height = get_viewport().get_visible_rect().size.y
	position.y = height/2
	size.y = height/2
	$Label.visible = false
	#pass # Replace with function body.

#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	

func set_text(text:String) -> void:
	$Label.text = text
	$Label.visible = true
	$AnimationPlayer.play("fade_out")
