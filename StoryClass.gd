extends Control

var normal_font = Color(0.305882, 0.431373, 0.376471)
onready var rich_text_nextable = false #True if Output can be clicked to go to the next block of text to be displayed, false if it can't
onready var messages_list = [] #List of strings to be printed one by one to the Output RichTextlabel

func fail():
	$Output.clear() #Clears the label
	$MiniScene.visible = false
	#Messages() Text
	rich_text_nextable = true
	messages_list = ["After 20 days, the town is overcome with the monsters of the surrounding woods.", "The town has fallen. But perhaps, in another timeline, the magic of the rats can still be saved."]
	$Output.call_deferred("set_text", messages_list)
	yield($Output, "messages_empty") #Wait for messages() to signal that there's no more messages to display
	#Text
	$Output.push_color(normal_font)
	$Output.push_meta("change_scene")
	$Output.append_bbcode('[center]Perhaps...')

func starting_scene(main_color, spot_type1, spot_color1, spot_type2 = null, spot_color2 = null):
	$MiniScene.texture = load("res://art/mini_scenes/mini_scene_glove.png")
	$MiniScene.material.set('shader_param/modulate', main_color) #Set main color of the first rat
	if spot_type1 != "res://art/sprite_sheets/rat/left_eye_spot.png":
		print("Spot 1: " + spot_type1.substr(28))
		$Spot1.texture = load("res://art/mini_scenes/" +  spot_type1.substr(28)) #Set texture of first spot
		$Spot1.self_modulate = spot_color1 #Set color of first spot
	if spot_type2 != null and spot_type2 != "res://art/sprite_sheets/rat/left_eye_spot.png":
		print("Spot 2: " + spot_type2.substr(28))
		$Spot2.texture = load("res://art/mini_scenes/" +  spot_type2.substr(28)) #Set texture of second spot
		$Spot2.self_modulate = spot_color2 #Set color of second spot
	$Output.clear() #Clears the label
	#Messages() Text
	rich_text_nextable = true 
	messages_list = ["Don\'t worry little one, you're safe now.", "I promise to find your friends..."]
	$Output.call_deferred("set_text", messages_list)
	yield($Output, "messages_empty") #Wait for messages() to signal that there's no more messages to display
	yield($Output, "next_message") #Wait for messages() to signal that there's no more messages to display
	fade_out()

func fade_out():
	for n in get_children():
		if n.name != "Tween" and n.name != "Background":
			print("tweeening")
			$Tween.interpolate_property(n, "self_modulate:a", 1, 0, 1)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()

func _on_Output_meta_clicked(meta):
	if meta == "change_scene":
		Global.inventory = {}
		get_tree().change_scene("res://start_menu/StartMenu.tscn")
