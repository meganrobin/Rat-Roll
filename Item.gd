extends Control

var base_item
var quantity
var color_name

func _ready():
	pass

func set_item(base, quant, col_name = null): #base item, quantity to add, optional String with the color name
	print("ITEM: SET ITEM")
	if col_name != null: #Item has color
		Global.inventory[col_name + ' ' + base] = {"base item": base, "quantity": quant, "color name": col_name} #Add new inventory entry
	else: #Item doesn't have color
		Global.inventory[base] = {"base item": base, "quantity": quant, "color name": null} #Add new inventory entry
	base_item = base
	quantity = quant
	color_name = col_name
	$TextureRect.texture = load(Global.items[base]["image"]) #Set texture
	if col_name: #Sets the color if a color name is given
		$TextureRect.material.set('shader_param/modulate', Global.items[base]["color list"][col_name])
	if quantity > 1:
		$QuantityLabel.text = String(quantity)

func increase_item_quantity(quant):
	print("ITEM: INCREASE ITEM QUANTITY")
	#Update global inventory dictionary
	if color_name != null: #Item has color
		Global.inventory[color_name + ' ' + base_item]["quantity"] += quant
	else: #Item doesn't have color
		Global.inventory[base_item]["quantity"] += quant
	#Update UI inventory
	quantity += quant
	$QuantityLabel.text = String(quantity)

func decrease_item_quantity(quant):
	print("ITEM: DECREASE ITEM QUANTITY")
	if quantity - quant <= 0: #Call queue_free() if all of the item is used up
		#Update UI inventory
		get_parent().item = null
		queue_free()
		#Update global inventory dictionary
		if color_name != null: #Item has color
			Global.inventory.erase(color_name + ' ' + base_item)
		else: #Item doesn't have color
			Global.inventory.erase(base_item)
	else: #Decrease quantity if the item isn't all used up
		#Update UI inventory
		quantity -= quant
		if quantity >= 1:
			$QuantityLabel.text = String(quantity)
		#Update global inventory dictionary
		if color_name != null: #Item has color
			Global.inventory[color_name + ' ' + base_item]["quantity"] -= quant
		else: #Item doesn't have color
			Global.inventory[base_item]["quantity"] -= quant
