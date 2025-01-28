extends GridContainer
class_name Inventory

var inv : InventoryArray

@export var item_limit : int = 10
static var INV_BOX_SIZE : int = 30

func _init() -> void:
	inv = InventoryArray.new()

func _ready() -> void:
	var invgrid : Inventory = self
	for i in item_limit:
		var slot := InventorySlot.new()
		print(INV_BOX_SIZE)
		slot.init(Vector2(INV_BOX_SIZE,INV_BOX_SIZE))
		#slot.item_switched_inv.connect(_on_item_switched_inv)
		invgrid.add_child(slot)




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
