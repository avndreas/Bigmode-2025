extends CenterContainer
class_name InventorySlot


signal item_switched_inv

func init(cms: Vector2) -> void:
	custom_minimum_size = cms
	size = cms
	size_flags_horizontal = SIZE_EXPAND_FILL
	size_flags_vertical = SIZE_EXPAND_FILL
	set_anchors_preset(Control.PRESET_TOP_LEFT)
	#grow_horizontal = true
	#SIZE_EXPAND
	#grow_vertical = true
