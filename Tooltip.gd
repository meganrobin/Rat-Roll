extends PopupPanel

func _ready():
	pass
	
func populate_dice_data(nickname, number, uses_left, uses, modifier):
	$NinePatchRect/MarginContainer/VBoxContainer/Label1.append_bbcode(nickname + '\'s D' + String(number))
	$NinePatchRect/MarginContainer/VBoxContainer/Label2.append_bbcode(String(uses_left) + '/' + String(uses) + ' uses left')
	if modifier != null:
		$NinePatchRect/MarginContainer/VBoxContainer/Label3.append_bbcode(modifier)

func populate_item_data(base_item, quantity, type, color_name = null):
	$NinePatchRect/MarginContainer/VBoxContainer/Label3.queue_free()
	if color_name == null: #Item doesn't have a color
		$NinePatchRect/MarginContainer/VBoxContainer/Label1.append_bbcode(base_item)
	else: #Item has a color
		$NinePatchRect/MarginContainer/VBoxContainer/Label1.append_bbcode(color_name + ' ' + base_item)
	#Set item type
	if type == "head accessory" or type == "accessory":
		$NinePatchRect/MarginContainer/VBoxContainer/Label2.append_bbcode("wearable")
	elif type == "food":
		$NinePatchRect/MarginContainer/VBoxContainer/Label2.append_bbcode("food")

func _process(_delta) -> void:
	#Calculate tooltip position
	if visible:
		#self.set_global_position(get_global_mouse_position() - Vector2(0,59))
		self.set_global_position(Vector2(clamp(stepify(get_global_mouse_position().x, 0.1), 0, 690), clamp(stepify(get_global_mouse_position().y - $NinePatchRect.rect_size.y, 0.1), 0, 720)))
