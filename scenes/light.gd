extends Node3D

@onready var light: OmniLight3D = %Light


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	light.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggleLight() -> bool:
	if light.visible:
		light.visible = false
	else:
		light.visible = true
	return light.visible

func getLightStatus() -> bool:
	return light.visible

func setLightStatus(lightStatus: bool):
	light.visible = lightStatus
