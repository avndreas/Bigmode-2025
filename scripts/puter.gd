extends Node3D

@onready var lines : VBoxContainer = %Lines
var level : Level

func format_time(time : float) -> String:
	return str(time).pad_decimals(0)

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var temp_level = get_tree().get_current_scene()
	if temp_level is Level:
		level = temp_level
		level.game_state_update.connect(update_screen)
		
		for child in lines.get_children():
			lines.remove_child(child)
			child.queue_free()
		
		var label_settings = load("res://assets/puter_text_settings.tres")
		
		
		var temp_label := Label.new()
		temp_label.label_settings = label_settings.duplicate()
		temp_label.text = "Lights: " + ("OK" if level.lights_on else ("ERROR: " + format_time(level.lights_off_time) + "s offline"))
		temp_label.name = "Lights"
		lines.add_child(temp_label)
		
		
		temp_label = Label.new()
		temp_label.label_settings = label_settings.duplicate()
		temp_label.text = "Oxygen Generator: " + ("OK" if level.oxygen_on else ("ERROR: " + format_time(level.oxygen_off_time) + "s offline"))
		temp_label.name = "Oxygen"
		lines.add_child(temp_label)
		
		temp_label = Label.new()
		temp_label.label_settings = label_settings.duplicate()
		temp_label.text = "Gas Pipes: " + ("OK" if level.gas_on else ("ERROR: " + format_time(level.gas_off_time) + "s offline"))
		temp_label.name = "Gas"
		lines.add_child(temp_label)
		
		var crit_events = get_tree().get_nodes_in_group("CriticalEvents")
		for event in crit_events:
			var event_label = Label.new()
			event_label.label_settings = label_settings.duplicate()
			event_label.name = str(event)
			#event_label.text = event.name + ": " + ("Online" if event.timer.time_left > 0 else "Offline")
			lines.add_child(event_label)

#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func update_screen(game_update : GameStateUpdate) -> void:
	
	#print("howdy")
	

		
	if level:
		
		if game_update.light:
			for line : Label in lines.get_children():
				
				if line.name == "Lights":
					if game_update.light_on:
						line.text = "Lights: OK"
						line.label_settings.font_color = Color.WHITE
					else:
						line.text = "Lights: ERROR: " + format_time(game_update.light_off_time) + "s offline"
						line.label_settings.font_color = Color.RED
		
		
		if game_update.crit_event:
			var event : CriticalEvent = game_update.crit_event
			for line in lines.get_children():
				#print(str(game_update.crit_event).replace(":", "_"))
				#print(line.name)
				if line.name == str(event).replace(":", "_"):
					if event.timer.time_left > 0:
						line.text = event.name + ": Online"
						line.label_settings.font_color = Color.WHITE
					else:
						line.text = event.name + ": Offline"
						line.label_settings.font_color = Color.RED
					#print("hi")
		##if level.lights_on:
		#var temp_label := Label.new()
		#temp_label.text = "Lights: " + ("OK" if level.lights_on else ("ERROR: Time since last online - " + str(level.lights_off_time)))
		#lines.add_child(temp_label)
		#
		#temp_label = Label.new()
		#temp_label.text = "Oxygen Generator: " + ("OK" if level.oxygen_on else ("ERROR: Time since last online - " + str(level.oxygen_off_time)))
		#lines.add_child(temp_label)
			
		#level.get_groups()
	pass
