extends Node
class_name InventoryArray

var _content : Array[Item] = []

func add_item(item:Item):
	#print(item)
	_content.append(item)
	#print("added:", _content)

func remove_item(item:Item):
	_content.erase(item)

func get_items() -> Array[Item]:
	return _content

func get_item(index : int) -> Item:
	#print(index, " ", _content.size())
	if index >= 0 and index < _content.size():
		#print("yep")
		return _content[index]
	return null

func is_empty():
	return _content.is_empty()
