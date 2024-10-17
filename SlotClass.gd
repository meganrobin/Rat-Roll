extends Panel

var ItemClass = preload("res://Item.tscn")
var item = null #The current item in the slot, or null if there's nothing in the slot

func _ready():
	pass

func put_into_slot(new_item):
	item = new_item
	item.position = Vector2(0,0)

func remove_from_slot():
	remove_child(item)
	item = null

func initialize_item(base, quant, col_name = null):
	print("SLOT: INITIALIZE SLOT")
	item = ItemClass.instance()
	add_child(item)
	item.rect_position = Vector2(8,8) #Set position of the item node relative to the slot
	item.set_item(base, quant, col_name)
