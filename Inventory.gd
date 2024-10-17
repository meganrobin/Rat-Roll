extends Control

const SlotClass = preload("res://SlotClass.gd")
var TooltipClass = preload("res://Tooltip.tscn")
const RatClass = preload("res://RatClass.gd")
var normal_stylebox = preload("res://slot_normal_stylebox.tres")
var clicked_stylebox = preload("res://slot_clicked_stylebox.tres")
var selected_slot = null

func _ready():
	for inv_slot in $TextureRect/GridContainer.get_children():
		inv_slot.connect("gui_input", self, "slot_gui_input", [inv_slot])
		inv_slot.connect("mouse_entered", self, "slot_mouse_entered", [inv_slot])
		inv_slot.connect("mouse_exited", self, "slot_mouse_exited", [inv_slot])
	shift()

func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event.is_action_pressed("MOUSE_LEFT"): #If event is a left mouse click
		if slot.item != null: #Makes sure player isn't just clicking on an empty slot
			if slot == selected_slot: #Deselect the item if it was already selected
				selected_slot = null
				slot.set('custom_styles/panel', normal_stylebox)
			elif selected_slot == null: #No item selected yet, so selected_slot just becomes the clicked slot
				selected_slot = slot
				slot.set('custom_styles/panel', clicked_stylebox)
			else: #A different item was already selected, so prevent player from picking multiple items at once
				selected_slot.set('custom_styles/panel', normal_stylebox)
				slot.set('custom_styles/panel', clicked_stylebox)
				selected_slot = slot

func slot_mouse_entered(slot: SlotClass):
	if slot.item != null:
		slot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		var tooltip_instance = TooltipClass.instance()
		tooltip_instance.populate_item_data(slot.item.base_item, slot.item.quantity, Global.items[slot.item.base_item]["identifiers"][0], slot.item.color_name)
		add_child(tooltip_instance)
		tooltip_instance.show()

func slot_mouse_exited(slot: SlotClass):
	if slot.item != null:
		slot.mouse_default_cursor_shape = Control.CURSOR_ARROW
		get_node("Tooltip").free()

func add_item(base, quant, col_name = null):
	for inv_slot in $TextureRect/GridContainer.get_children():
		if inv_slot.item != null:
			if inv_slot.item.base_item == base and inv_slot.item.color_name == col_name: #Item already exists in the inventory, so just increase it's quantity
				inv_slot.item.increase_item_quantity(quant)
				break #Stop iterating over intentory slots
		if inv_slot.item == null: #Current slot has no item, so you can add the item here
			inv_slot.initialize_item(base, quant, col_name)
			break #Stop iterating over intentory slots

func remove_item(base, quant, col_name = null):
	print("REMOVE ITEM")
	for inv_slot in $TextureRect/GridContainer.get_children():
		if inv_slot.item != null:
			if inv_slot.item.base_item == base and inv_slot.item.color_name == col_name: #Item already exists in the inventory, so just decrease it's quantity
				inv_slot.item.decrease_item_quantity(quant)
				shift()
				break #Stop iterating over intentory slots
	return [base, quant, col_name]

func shift(): #Remove any empty space between items in the inventory so that it looks nice
	print("SHIFT INVENTORY")
	if selected_slot != null:
		selected_slot.set('custom_styles/panel', normal_stylebox) #Change the selected slot's stylebox from clicked to normal
		selected_slot = null
	var slots = $TextureRect/GridContainer.get_children()
	#Remove all items from the slots(if any)
	for inv_slot in slots:
		if inv_slot.item != null: #There's an item in the slot
			inv_slot.item.queue_free() #Physically remove item
			inv_slot.item = null #Set slot's item var to null
	#Add all inventory items back into the slots by using the Global inventory dictionary
	for i in range(Global.inventory.size()):
		slots[i].initialize_item(Global.inventory.values()[i]["base item"], Global.inventory.values()[i]["quantity"], Global.inventory.values()[i]["color name"])

func _on_InventoryButton_pressed():
	shift()
	if rect_position.y == 0: #Inventory is down, needs to go back up
		rect_position.y = -172
	else: #Inventory is up, needs to be shown
		rect_position.y = 0

# Hides inventory only if it's showing
func hide_inventory(): 
	if rect_position.y == 0:
		rect_position.y = -172
