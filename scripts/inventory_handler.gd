extends GridContainer
class_name Inventory

var inv : InventoryArray

@export var item_limit : int = 10
@export var ybuffer : float = 5
@export var xbuffer : float = 5
static var INV_BOX_SIZE : int = 20

func _init() -> void:
	inv = InventoryArray.new()

func _ready() -> void:
	var horizontal_view = get_viewport_rect().size.x
	INV_BOX_SIZE = int(((horizontal_view * 2 / 3) - ((item_limit +1)*xbuffer))/(item_limit))
	#print(INV_BOX_SIZE)
	
	
	
	var invgrid : Inventory = self
	for i in item_limit:
		var slot := InventorySlot.new()
		#print(INV_BOX_SIZE)
		slot.init(Vector2(INV_BOX_SIZE,INV_BOX_SIZE))
		#slot.item_switched_inv.connect(_on_item_switched_inv)
		invgrid.add_child(slot)
		
		
	
	invgrid.size = Vector2(item_limit * INV_BOX_SIZE + (item_limit+1)*xbuffer, INV_BOX_SIZE + (ybuffer*2))
	invgrid.position.y -= INV_BOX_SIZE + (ybuffer*2)
	




func refresh_inventory():
	var invgrid : Inventory = self
	#print("inv size: ", inventory.get_items().size())
	if !inv:
		return
	
	var counter = 0
	#print("slot children: ", invgrid.get_children())
	for slot in invgrid.get_children():
		if counter >= 10:
			break
		for slot_child in slot.get_children():
			slot_child.queue_free()
		if inv.get_item(counter) != null:
			var item := InventoryItem.new()

			item.init(inv.get_item(counter))
			slot.add_child(item)
			#print("hi ", counter)
			
		counter += 1
		
func has_item_of_type(type : Item.Items) -> bool:
	for item in inv.get_items():
		if item.type == type:
			return true
	return false
	
func get_item_of_type(type : Item.Items) -> Item:
	for item in inv.get_items():
		if item.type == type:
			return item
	return null
	
func pop_item_of_type(type : Item.Items) -> Item:
	for item in inv.get_items():
		if item.type == type:
			print(item.type, " ", type)
			inv.remove_item(item)
			refresh_inventory()
			return item
	return null
	
func push_item(item : Item) -> void:
	inv.add_item(item)
	refresh_inventory()
