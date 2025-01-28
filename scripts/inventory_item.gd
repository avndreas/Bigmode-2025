extends TextureRect
class_name InventoryItem


var data : Item


func init(d: Item) -> void:
	data = d
	texture = data.UI_sprite
	
	tooltip_text = "%s\n%s\n%s" % [data.name, 
						data.description]
	expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	custom_minimum_size = Vector2(Inventory.INV_BOX_SIZE,Inventory.INV_BOX_SIZE)
