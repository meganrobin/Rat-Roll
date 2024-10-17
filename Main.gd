extends Control

#Preload Classes
const RatClass = preload("res://RatClass.gd") #Loads the Rat Class script
const RatClassNode = preload("res://RatClass.tscn") #Loads the Rat Class to be able to create new instances of it
const D6ClassNode = preload("res://D6Class.tscn") #Loads the D6 Class to be able to create new instances of it
const FleasClassNode = preload("res://FleasClass.tscn") #Loads the Fleas Class to be able to create new instances of it
const StoryClassNode = preload("res://StoryClass.tscn") #Loads the Fleas Class to be able to create new instances of it
const StartMenu = preload("res://start_menu/StartMenu.tscn")

#Font Colors
var normal_font = Color(0.305882, 0.431373, 0.376471)
var red_font = Color(0.529412, 0.019608, 0.133333)

#Visible Variables
var days = 1
var current_population = 0
var available_population = 7 #The maximum avaible population is 9

#Functionality Variables
var event_number
var current_bio_index = 0
var main_options_list = ["north", "rat", "fish", "sand", "bug", "trash", "west"]

onready var invent = get_node("UI/Inventory")
#Each inventory entry: inventory[0][0] = inventory[0][0] = base item name, inventory[0][1] = amount, inventory[0][2] = color name
#Example: "blueberry" : ["blueberry", 1], "white daisy" : {"daisy", 3, "white"}
var inventory = Global.inventory

#Dice Variables
var dice_types = {6:["res://art/dice/D6.png", "res://art/dice/D6_disabled.png", "res://art/dice/D6_selected.png"], 8:["res://art/dice/D8.png", "res://art/dice/D8_disabled.png", "res://art/dice/D8_selected.png"], 10:["res://art/dice/D10.png", "res://art/dice/D10_disabled.png", "res://art/dice/D10_selected.png"], 12:["res://art/dice/D12.png", "res://art/dice/D12_disabled.png", "res://art/dice/D12_selected.png"], 20:["res://art/dice/D20.png", "res://art/dice/D20_disabled.png", "res://art/dice/D20_selected.png"]}
var current_dice = []
var dice_amount_needed = 6 #The minimum dice number needed to pass, this variable changes with each dice event
var global_leave_meta
var outcome_function #The function to call after a roll

#Location Variables
#Each location works like this: [name of location, Vector2D with the position of where the rat should go, boolean that is true when a rat is occupying the location and false when it's empty]
var locations = [["location1", Vector2(400,376), false], ["location2", Vector2(400,380), false], ["location3", Vector2(400,376), false], ["location4", Vector2(400,380), false], ["location5", Vector2(400,376), false], ["location6", Vector2(400,380), false], ["location7", Vector2(400,376), false], ["location8", Vector2(400,380), false],]

#Rat Creation Variables
var rat_variables = []
var rat_names = ["Alberto", "Blaze", "Bo", "Bongo", "Bradford", "Brie", "Cady", "Charles", "Clementine", "Cleo", "Coden", "Cranberry", "Crumb", "Curly", "Cypress", "Dancer", "Disco", "Drew", "Duchess", "Eden", "Fern", "Freckles", "Frill", "Garnet", "Ghost", "Gloss", "Glump", "Goo", "Gravel", "Gus", "Harry", "Ingrid", "Jam", "Jamie", "Jellybean", "Juju", "Jules", "Juliette", "Juniper", "Jupiter", "Kelly", "Lexi", "Maple", "Marsh", "Mattie", "Max", "Midnight", "Mina", "Moe", "Moxie", "Muffin", "Olive", "Pebble", "Phantom", "Piper", "Pop", "Poppy", "Rock", "Saturn", "Shoelace", "Spike", "Splash", "Squash", "Star", "Sting", "Stinky", "Storm", "Tiny", "Ziggy", "Zoe"]
#Rat Color/Spots Variables
export var color_names = ["red", "red orange", "orange", "yellow", "green", "dark green", "light blue", "blue", "dark blue", "periwinkle", "purple", "dark purple", "pink"]
export var colors = [Color(0.529412, 0.019608, 0.133333), Color(0.688477, 0.145257, 0.08606), Color(0.760784, 0.356863, 0.137255), Color(0.901961, 0.760784, 0.305882), Color(0.552941, 0.721569, 0.329412), Color(0.196078, 0.423529, 0.007843), Color(0.752941, 0.929412, 0.952941), Color(0.415686, 0.635294, 0.776471), Color(0.235294, 0.47451, 0.619608), Color(0.422974, 0.422974, 0.644531), Color(0.388235, 0.247059, 0.603922), Color(0.25098, 0.145098, 0.411765), Color(0.752941, 0.086275, 0.384314)]
onready var spot_textures = ["res://art/sprite_sheets/rat/big_stripe.png", "res://art/sprite_sheets/rat/dots.png", "res://art/sprite_sheets/rat/face_patch.png", "res://art/sprite_sheets/rat/head_patch.png", "res://art/sprite_sheets/rat/left_eye_spot.png", "res://art/sprite_sheets/rat/patch.png", "res://art/sprite_sheets/rat/right_eye_spot.png", "res://art/sprite_sheets/rat/stripes.png"]

#Rat Personality Variables
var rat_personalities = [["normal", ], ["hungry", ], ["evil", ], ["prankster", ], ["fancy", ], ["promiscuous", ]]

#Rat Likes and Dislikes Variables
var all_likes = ["baths", "stinky things", "earrings", "sweets", "vegetables", "fruit", "seafood", "squids", "coral", "starfish", "shells", "spiral shells", "shoes", "sneakers", "donuts", "honeycombs", "carrots", "pastries", "muffins", "pies", "flowers", "clovers", "roses", "daisies", "tulips", "lily pads"]
var likes = []
var dislikes = []
var items = Global.items

#Fishing Variables
var fishing_items = ["coral", "shrimp", "soda", "squid", "lily pad", "earring", "earrings", "sneakers"]
#Flower picking Variables
var flower_items = ["rose", "daisy", "tulip", "clover", "mushroom"]
#Sand Variables
var sand_items = ["coral", "scallop shell", "spiral shell", "starfish", "oyster shell"]
#Cave Variables
var cave_items = ["mushroom", "apple", "blueberry", "orange", "pear", "nugget"]
#Trash Variables
var trash_items = ["donut", "soda", "pizza"]

func _ready():
	randomize() #randomize() must be called in order for all randi() methods to work
	rat_variables = create_rat() #Create and add the first rat
	add_rat()
	#Start the starting scene, passing in the first rat's spot textures and colors
	var story_instance = StoryClassNode.instance()
	$UI.add_child(story_instance)
	story_instance.starting_scene(rat_variables[4], rat_variables[5], rat_variables[6], rat_variables[7], rat_variables[8])
	#Explain how the game works, controls
	wake_up()
	#Alphabetically sort the rat_names array (This should be deleted eventually)
#	rat_names.sort() 
#	var new_rat_names = []
#	for n in rat_names:
#		new_rat_names.append("\"" + n + "\"")
#	print(new_rat_names)

func wake_up():
	#Tween $blackbackground
	var tween = get_tree().create_tween()
	tween.tween_property($BlackBackground, "modulate:a", 0, .25)
	Global.state = "item_state"
	#Stop fireflies
	$Fireflies.emitting = false
	$Fireflies.visible = false
	for r in get_tree().get_nodes_in_group("rats"): #Restart all rat movement timers to get them out of sleep state
		r.get_node("Timer").start()
	main_options()

func main_options():
	$BlackBackground.modulate.a = 0.0
	$UI/Output.clear() #Clears the label
	$UI/Output.append_bbcode('What do you want to do?')
	#Choices
	$UI/Output.push_color(normal_font)
	$UI/Output.append_bbcode('[center][url=forest_setup]Explore the forest.[/url]')
	$UI/Output.append_bbcode('[center][url=town_setup]Visit the town.[/url]')
	$UI/Output.append_bbcode('[center][url=sleep]Sleep.[/url]')

func roll_dice_setup(leave_meta, outcome_func, dice_amount_need):
	$UI/Output.clear() #Clears the label
	global_leave_meta = leave_meta
	outcome_function = outcome_func
	dice_amount_needed = dice_amount_need
	var usages = [] #List to hold the boolean t or f of each current die's used variable

	for d in current_dice:
		d.flash_animation()
		usages.append(d.used)
		if !d.used: #Makes the unused dice clickable
			d.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			d.clickable = true

	if false in usages: #If at least one dice is usable
		$UI/Output.append_bbcode('Choose dice.\n\n')
		$UI/RollButton.visible = true
		$UI/RollButtonLabel.visible = true
		$UI/RollButton.mouse_filter = Control.MOUSE_FILTER_PASS
		#Choices
		$UI/Output.push_color(normal_font)
		$UI/Output.push_meta(leave_meta)
		$UI/Output.append_bbcode('[center]Never mind.')
	else: #If no dice are usable
		if current_population > 1:
			$UI/Output.append_bbcode('Your rats are too tired!')
		else:
			$UI/Output.append_bbcode(get_tree().get_nodes_in_group("rats")[0].nickname + ' is too tired!')
		#Choices
		$UI/Output.push_color(normal_font)
		$UI/Output.push_meta(leave_meta)
		$UI/Output.append_bbcode('[center]Aw rats.')

func _on_RollButton_pressed():
	invent.hide_inventory()
	var dice_choice = []
	for d in current_dice:
		if d.selected:
			dice_choice.append(d)
	if dice_choice != []: #Ensures there's actually one or more dice selected
		$UI/Output.clear() #Clears the label
		#Hides the Roll Button and makes it unable to take mouse clicks
		$UI/RollButton.visible = false
		$UI/RollButtonLabel.visible = false
		$UI/RollButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
		#Makes the selected dice now deselected and unselectable(until player sleeps)
		for d in current_dice:
			d.selected = false
			d.get_node("SelectedHighlight").visible = false
			d.clickable = false
			d.mouse_default_cursor_shape = Control.CURSOR_ARROW
		#Calls the roll function of each dice
		var total = 0
		for d in dice_choice:
			total += d.roll()
			yield(get_tree().create_timer(.5), "timeout")
		yield(get_tree().create_timer(.6), "timeout")
		#Makes any used dice look unclickable
		for d in dice_choice:
			if d.used:
				d.get_node("DisabledLayer").visible = true
		if outcome_function is String: #outcome_function is either rat_outcome or town_outcome
			if total >= dice_amount_needed: #Pass
				call(outcome_function, true)
			elif total < dice_amount_needed: #Fail
				call(outcome_function, false)
		else: #outcome_function is [pass_text, fail_text, item_list]
			if total >= dice_amount_needed: #Pass
				item_outcome(true, outcome_function[0], outcome_function[2], global_leave_meta)
			elif total < dice_amount_needed: #Fail
				item_outcome(false, outcome_function[1], outcome_function[2], global_leave_meta)

#Parameter last_location is a string w/ the name of the function to return to, the function recalls it using para if needed
func leave(last_location, para = ""):
	#Makes all the potential rat sprites invisible again
	$DiceAnimationPlayer.play("Dice Out")
	for n in $PotentialRat.get_children():
		n.visible = false
	#Hides the mini scene
	$MiniScene.visible = false
	#Hides the notebooks
	$UI/LeftNotebook.visible = false
	$UI/RightNotebook.visible = false
	#Removes the FloatingItem instance if it exists
	if get_node_or_null("FloatingItem"):
		$FloatingItem.queue_free()
	#Makes sure all the dice are deselected and their frame is the max number
	for d in current_dice:
		d.clickable = false
		d.selected = false
		d.get_node("SelectedHighlight").visible = false
		d.get_node("Number").frame = d.number - 1
	$UI/RollButton.visible = false
	$UI/RollButtonLabel.visible = false
	$UI/RollButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if para == "": #No params needed for last_location
		call(last_location)
	else: #Params needed for last_location
		call(last_location, para)

func forest_setup():
	$BlackBackground.modulate.a = 1.0
	$MiniScene.texture = load("res://art/mini_scenes/mini_scene_forests.png")
	$MiniScene.visible = true
	$UI/Output.clear() #Clears the label
	$UI/Output.append_bbcode('The forest extends around you.')
	$UI/Output.push_color(normal_font)
	if "west" in main_options_list:
		$UI/Output.append_bbcode('[center][url=west]Go West.[/url]	')
	$UI/Output.append_bbcode('[url=north]Go North.[/url]	')
	if "fish" in main_options_list or "sand" in main_options_list:
		$UI/Output.append_bbcode('[url=east]Go East.[/url]')
	$UI/Output.push_meta(["leave", "main_options"])
	$UI/Output.append_bbcode('[center]Leave.')

func forest(forest_choice):
	$BlackBackground.modulate.a = 1.0
	$UI/Output.clear() #Clears the label
	if forest_choice == "north":
		$MiniScene.texture = load("res://art/mini_scenes/mini_scene_ruins.png")
		$MiniScene.visible = true
		#Text
		$UI/Output.append_bbcode('An ancient stone altar emerges amist a sea of flowers.')
		#Choices
		$UI/Output.push_color(normal_font)
		$UI/Output.push_meta(["roll_dice_setup", ["leave", "forest", "north"], ["You picked ", "Just dirt.", flower_items], 3])
		$UI/Output.append_bbcode('[center]Search the flowers - roll 3 to pass.')
		$UI/Output.append_bbcode('[center][url=new_rat_setup]Approach altar.')
		$UI/Output.push_meta(["leave", "forest_setup"])
		$UI/Output.append_bbcode('[center]Leave.')
	elif forest_choice == "west":
		$MiniScene.texture = load("res://art/mini_scenes/mini_scene_lake.png")
		$MiniScene.visible = true
		#Text
		$UI/Output.append_bbcode('You see a lake surrounded by sand.')
		#Choices
		$UI/Output.push_color(normal_font)
		if "fish" in main_options_list:
			$UI/Output.push_meta(["roll_dice_setup", ["leave", "forest", "west"], ["You reeled in ", "Looks like nothing's biting.", fishing_items], 3])
			$UI/Output.append_bbcode('[center]Go fishing - roll 3 to pass.')
		if "sand" in main_options_list:
			$UI/Output.push_meta(["roll_dice_setup", ["leave", "forest", "west"], ["You dug up ", "You got sand in your fingernails.", sand_items], 2])
			$UI/Output.append_bbcode('[center]Search the sand - roll 2 to pass.')
		$UI/Output.push_meta(["leave", "forest_setup"])
		$UI/Output.append_bbcode('[center]Leave.')
	elif forest_choice == "east":
		$MiniScene.texture = load("res://art/mini_scenes/mini_scene_cave.png")
		$MiniScene.visible = true
		#Text
		$UI/Output.append_bbcode('A dark cave looms before you.')
#		for rat in get_tree().get_nodes_in_group("rats"):
#			if "stinky things" in rat.likes:
#				$UI/Output.append_bbcode(rat.nickname + ' looks especially excited.')
		#Choices
		$UI/Output.push_color(normal_font)
		$UI/Output.push_meta(["roll_dice_setup", ["leave", "forest", "east"], ["You found ", "You got scared and left.", cave_items], 4])
		$UI/Output.append_bbcode('[center]Explore the cave - roll 4 to pass.')
		$UI/Output.push_meta(["leave", "forest_setup"])
		$UI/Output.append_bbcode('[center]Leave.')

#New Rat Events
func new_rat_setup():
	$UI/Output.clear() #Clears the label
	var total_happiness = true
	for rat in get_tree().get_nodes_in_group("rats"):
		if rat.happiness < 10:
			total_happiness = false
			break
	if total_happiness: #If all the rats are at 100% happiness, allow a new rat to be summoned
		if "rat" in main_options_list and current_population < available_population: #If a rat hasn't been summoned today and the amount of rats isn't at max
			main_options_list.erase("rat") #Removes "rat" from the main_options_list
			#Creates a potential rat
			rat_variables = create_rat()
			#Start rat apperance animation
			$AnimationPlayer.play("Appear")
			yield(get_tree().create_timer(.6), "timeout")
			#Shows player what the rat looks like [nickname, likes, dislikes, grouping, main_color, spot_type1, spot_color1, spot_type2, spot_color2, family, dice_type, dice_uses]
			$PotentialRat/Body.material.set('shader_param/modulate', rat_variables[4])
			$PotentialRat/Body.visible = true #Make potential main sprite of the rat visible
			#Set 1st spots
			$PotentialRat/Spot1.texture = load(rat_variables[5])
			$PotentialRat/Spot1.self_modulate = rat_variables[6]
			$PotentialRat/Spot1.visible = true #Make first potential spots visible
			#Set 2nd spots, if given
			if rat_variables[7] != null: 
				$PotentialRat/Spot2.texture = load(rat_variables[7])
				$PotentialRat/Spot2.self_modulate = rat_variables[8]
				$PotentialRat/Spot2.visible = true #Make first potential spots visible
			#Shows player what the die looks like using the potential dice and rat_variables
			$PotentialRat/Dice.texture = load(dice_types[rat_variables[10]][0]) #Get the dice texture from the dice_types dictionary
			$PotentialRat/Dice.self_modulate = rat_variables[4] #Sets color of dice's body
			$PotentialRat/DiceNumbers.self_modulate = rat_variables[6] #Sets color of dice's numbers
			$DiceAnimationPlayer.play("Dice In")
			var sparkles = load("res://Sparkles.tscn").instance()
			sparkles.position = $PotentialRat/Dice.position
			add_child(sparkles)
			sparkles.get_node("AnimationPlayer").play("Sparkle")
			
			#Sets the dice bar to pass based on how many rats the player currently has
			var needed_roll = (current_population * 4)
			
			#Show info on the left notebook pages
			for label in $UI/LeftNotebook/M/V.get_children(): #Clear each left notebook label
				label.clear()
			$UI/LeftNotebook/M/V/TypeLabel.append_bbcode('Type: D' + String(rat_variables[10]))
			$UI/LeftNotebook/M/V/UsesLabel.append_bbcode('Uses: ' + String(rat_variables[11]))
			#$UI/LeftNotebook/M/V/ModifierLabel.append_bbcode('Modifier: ' + PoolStringArray(rat_variables[2]).join(", "))
			$UI/LeftNotebook.visible = true
			#Show info on the right notebook pages
			for label in $UI/RightNotebook/M/V.get_children(): #Clear each right notebook label
				label.clear()
			$UI/RightNotebook/M/V/NicknameLabel.append_bbcode('Name: ' + rat_variables[0])
			$UI/RightNotebook/M/V/LikesLabel.append_bbcode('Likes: ' + PoolStringArray(rat_variables[1]).join(", "))
			$UI/RightNotebook/M/V/DislikesLabel.append_bbcode('Dislikes: ' + PoolStringArray(rat_variables[2]).join(", "))
			$UI/RightNotebook.visible = true
			#Text
			$UI/Output.append_bbcode('A rat emerges from the shrine!\n')
			#Choices
			$UI/Output.push_color(normal_font)
			$UI/Output.push_meta(["roll_dice_setup", ["leave", "forest", "north"], "rat_outcome", needed_roll])
			$UI/Output.append_bbcode('[center]Ask the rat to join you - roll ' + str(needed_roll) + ' to pass.')
			$UI/Output.push_meta(["leave", "forest", "north"])
			$UI/Output.append_bbcode('[center]Leave.')
		elif "rat" in main_options_list and current_population >= available_population: #If a rat hasn't been summoned today but the amount of rats is at max
			$UI/Output.append_bbcode('You have reached the maximum rat capacity.\n')
			$UI/Output.push_color(normal_font)
			$UI/Output.push_meta(["leave", "forest", "north"])
			$UI/Output.append_bbcode('[center]Aw rats.')
		else:
			$UI/Output.append_bbcode('You may only attempt to summon a rat once per day.\n')
			$UI/Output.push_color(normal_font)
			$UI/Output.push_meta(["leave", "forest", "north"])
			$UI/Output.append_bbcode('[center]Aw rats.')
	else: #Not all rats have 100% happiness
		$UI/Output.append_bbcode('All rats must have 100% happiness to approach the altar.')
		$UI/Output.push_color(normal_font)
		$UI/Output.push_meta(["leave", "forest", "north"])
		$UI/Output.append_bbcode('[center]Aw rats.')

func rat_outcome(roll_result):
	#Hide the potential rat dice
	$DiceAnimationPlayer.play("Dice Out")
	if !roll_result: #Fail
		#Start backwards rat apperance animation
		$AnimationPlayer.play("Appear")
		yield(get_tree().create_timer(.6), "timeout")
		#Makes all the potential rat sprites invisible again
		for n in $PotentialRat.get_children():
			n.visible = false
		#Text
		$UI/Output.append_bbcode('The rat vanishes as quickly as it had appeared. You think about getting your eyes checked out.')
		$UI/Output.push_color(normal_font)
		$UI/Output.push_meta(["leave", "forest", "north"])
		$UI/Output.append_bbcode('[center]My word!')
	elif roll_result: #Pass
		#Text
		$UI/Output.append_bbcode(rat_variables[0] + ' is free! You have gained another rat.')
		$UI/Output.push_color(normal_font)
		$UI/Output.push_meta(["leave", "forest", "north"])
		$UI/Output.append_bbcode('[center]Hooray!')
		add_rat()

func item_outcome(roll_result, text, item_list, leave_meta):
	$UI/Output.clear() #Clears the label
	if !roll_result: #Fail
		#Text
		$UI/Output.append_bbcode(text)
		#Choice
		$UI/Output.push_color(normal_font)
		$UI/Output.push_meta(leave_meta)
		$UI/Output.append_bbcode('[center]Aww...')
	elif roll_result: #Pass
		item_list.shuffle()
		var item = create_item(item_list[0], 1) #Essentially, this picks a random base item name off the given item_list, and makes an inventory item from it, so var item = a list with [base_name, quantity, color_name(optional)]
		callv("add_item", item + [text])
		#Choice
		$UI/Output.push_color(normal_font)
		$UI/Output.push_meta(leave_meta)
		$UI/Output.append_bbcode('[center]Hooray!')

func town_setup():
	$UI/Output.clear() #Clears the label
	$BlackBackground.modulate.a = 1.0
	$MiniScene.texture = load("res://art/mini_scenes/mini_scene_town.png")
	$MiniScene.visible = true
	#Text
	$UI/Output.append_bbcode('The town\'s condition worsens by the day.')
	#Choices
	$UI/Output.push_color(normal_font)
	$UI/Output.push_meta(["roll_dice_setup", ["leave", "town_setup"], "town_outcome", 30])
	$UI/Output.append_bbcode('[center]Cast protection spell over the town - roll 30 to pass.')
	$UI/Output.push_meta(["leave", "main_options"])
	$UI/Output.append_bbcode('[center]Leave.')

func town_outcome(roll_result):
	if !roll_result: #Fail
		$UI/Output.append_bbcode('The rats tried their very best, but the spell wasn\'t strong enough to cover the entire town.')
		$UI/Output.push_color(normal_font)
		$UI/Output.push_meta(["leave", "main_options"])
		$UI/Output.append_bbcode('[center]Maybe one day.')
	elif roll_result: #Pass
		$UI/Output.append_bbcode('You did it! The town is saved!')
		$UI/Output.push_color(normal_font)
		$UI/Output.append_bbcode('[center]Hooray!')

func gift_setup():
	$UI/Output.clear() #Clears the label
	$UI/Output.append_bbcode('Pick an item, then pick the rat you want to give it to.')
	$UI/Output.push_color(normal_font)
	$UI/Output.push_align(RichTextLabel.ALIGN_CENTER)
	$UI/Output.append_bbcode('[center][url=main_options]Back.[/url]')

func rat_gui_input(viewport: Node, event: InputEvent, shape_idx: int, rat: RatClass):
	if event.is_action_pressed("MOUSE_LEFT") and invent.selected_slot != null and Global.state != "event_state": #If event is a left mouse click, and an inventory item is currently selected
		print("rat clicked")
		$UI/Output.clear() #Clears the label
		var reaction = rat.gift(invent.selected_slot.item) #rat.gift() funct will add the item in the correct way, and return a string with either "love", "hate", or "like"
		if reaction == "love":
			$UI/Output.append_bbcode(rat.nickname + ' loves the ' + invent.selected_slot.item.base_item + '!\n\n')
			increase_happiness(rat, 5)
		elif reaction == "hate":
			$UI/Output.append_bbcode(rat.nickname + ' hates the ' + invent.selected_slot.item.base_item + '!\n\n')
			decrease_happiness(rat, 5)
		elif reaction == "like":
			$UI/Output.append_bbcode(rat.nickname + ' likes the ' + invent.selected_slot.item.base_item + '!\n\n')
			increase_happiness(rat, 3)
		$UI/Output.push_color(normal_font)
		$UI/Output.append_bbcode('[center][url=main_options]Back.[/url]')
		invent.remove_item(invent.selected_slot.item.base_item, 1, invent.selected_slot.item.color_name)

func rat_mouse_entered(rat: RatClass):
	if invent.selected_slot != null:
		rat.highlight()

func rat_mouse_exited(rat: RatClass):
	rat.unhighlight()

func sleep(): #Called by meta when player clicks the "sleep" main option
	Global.state = "event_state"
	randomize()
	#Tween $blackbackground
	var tween = get_tree().create_tween()
	tween.tween_property($BlackBackground, "modulate:a", 0.9, 1)
	#Start the fireflies
	$Fireflies.visible = true
	$Fireflies.emitting = true
	main_options_list = ["north", "rat", "fish", "sand", "bug", "trash", "west"]
	#Makes all the dice usable again
	for d in current_dice:
		d.uses_left = d.uses
		d.used = false
		d.get_node("DisabledLayer").visible = false
	#Stops all the rats from doing the eat action
	for r in get_tree().get_nodes_in_group("rats"):
		r.has_food = false
		r.get_node("Timer").stop()
		r.current_state = 10 #Makes rat go into SLEEP state
	if days != 20: #Continute to the main updates
		#Increment days
		days += 1
		$UI/DayLabel.text = "Day " + str(days)
		main_updates()
	else: #Failed the game!
		var story_instance = StoryClassNode.instance()
		$UI.add_child(story_instance)
		story_instance.fail()
	
func main_updates():
	$UI/Output.clear() #Clears the label
	var messages_list = []
	#Things that happen before the main options are shown
	#Turn kid rats that have been alive for 3 days into an adult
	if get_tree().has_group("kid rats"):
		for k in get_tree().get_nodes_in_group("kid rats"):
			if k.days_alive == 3:
				$UI/Output.append_bbcode(k.nickname + ' is now an adult!')
				messages_list.append(k.nickname + ' is now an adult!')
				k.remove_from_group("kid rats")
				k.add_to_group("adult rats")
				k.scale = Vector2(4,4)
	#Remove temporary rats
	if get_tree().has_group("temporary rats"):
		for t in get_tree().get_nodes_in_group("temporary rats"):
			if t.days_alive == 3:
				messages_list.append(t.nickname + ' has to take their leave now.')
				current_population -= 1
				t.remove_from_group("temporary rats")
				t.remove_from_group("rats")
				current_dice.erase(t.die)
				t.die.queue_free()
				t.queue_free()
	
	#Check the each rat's conditions list, updating/removing as necessary
	for rat in get_tree().get_nodes_in_group("rats"):
		rat.days_alive += 1
		if rat.conditions != []: #If the rat has any conditions
			for condition in rat.conditions:
				if condition[0] == "fleas" and condition[1] == 0:
					for c in rat.get_children():
						if "Fleas" in c.name:
							c.queue_free()
					rat.conditions.erase(condition)
					messages_list.append(rat.nickname + '\'s fleas have gone away.')
				elif condition[0] == "rest" and condition[1] >= 1:
					rat.die.uses_left = 0
					rat.die.used = true
					rat.die.get_node("DisabledLayer").visible = true
					messages_list.append(rat.nickname + '\'s die will be unusable today while they rest.')
					condition[1] -= 1
				elif condition[0] == "rest" and condition[1] == 0:
					rat.conditions.erase(condition)
				elif condition[0] == "bad accessory":
					messages_list.append(rat.nickname + ' is still upset about ' + condition[1].nickname + '\'s ' + condition[2] + '.')
					decrease_happiness(rat, 1)
				else:
					condition[1] -= 1
	#Messages() text
	if !messages_list.empty():
		$UI/Output.call_deferred("set_text", messages_list)
		yield($UI/Output, "next_message") #Wait for messages() to signal that there's no more messages to display
	events() #Set up a random event

func events():
	#Random number created, this determines which random event will happen
	event_number = randi() % 8
	print("Event number: " + String(event_number))
	if event_number == 0: #Rat Friend Event - introduces a new rat to the crew with a blurb about them, and gives the user 2 choices: accept the rat, or reject the rat
#		if current_population < available_population:
#			#Setting the new rat's appearance
#			rat_variables = create_rat("temporary")
#
#			var all_rats = get_tree().get_nodes_in_group("rats") #Creates a list of all the adult rats on screen
#			var rat = all_rats.pop_at(randi() % len(all_rats))
#
#			#Messages() Text
#			rich_text_nextable = true
#			messages_list = ['A rat you\'ve never seen before appears at the settlement. ' + rat.nickname + ' seems to recognize the newcover, and looks delighted at their arrival.', 'You get the feeling that this rat won\'t stay here for long. But maybe they could help?']
#			call_deferred("messages")
#			yield(self, "messages_empty") #Wait for messages() to signal that there's no more messages to display
#			#After Messages() Text
#			$UI/Output.append_bbcode('Name: ' + rat_variables[0] + '\n')
#			$UI/Output.append_bbcode('Likes: ' + PoolStringArray(likes).join(", ") + '\n')
#			$UI/Output.append_bbcode('Dislikes: ' + PoolStringArray(dislikes).join(", "))
#			$UI/Output.push_color(normal_font)
#			$UI/Output.push_meta(["event_outcome", rat_variables[0] + " begins checking out the new space.", "add_rat"])
#			$UI/Output.append_bbcode('[center]Welcome the guest.')
#			$UI/Output.push_meta(["event_outcome", rat_variables[0] + " looks quite sad for a momment, then scurrys away. " + rat.nickname + " is disapointed.", ["decrease_happiness", rat, 3]])
#			$UI/Output.append_bbcode('[center]Reject entry.')
#		else:
#			events()
		events()
	elif event_number == 1: #Kid Rat Birth Event - a rat has given birth, creates a new instance of a kid rat
		var adult_rats = get_tree().get_nodes_in_group("adult rats")
		if adult_rats.size() >= 2 and current_population < available_population: #Checks if there's at least two adult rats in the rescue, and max rat limit hasn't been reached
			#Set parents
			var parent1 = adult_rats.pop_at(randi() % len(adult_rats))
			var parent2
			for r in adult_rats: #Prevent famiy members from having kids with eachother
				for f in [r] + r.family: #Iterates through all of the rat's family members plus the rat itself
					if not f in parent1.family: #Ensures the rat or the rat's family members are not also family members of parent1
						parent2 = r
			if parent2 == null:
				events()
			else:
				var spots_list = [parent1.get_node("Spot1").texture.resource_path, parent2.get_node("Spot1").texture.resource_path]
				if parent1.get_node("Spot2").visible: #If parent1 has a 2nd spot
					spots_list.append(parent1.get_node("Spot2").texture.resource_path)
				if parent2.get_node("Spot2").visible: #If parent2 has a 2nd spot
					spots_list.append(parent2.get_node("Spot2").texture.resource_path)
				#Call create_rat() function
				var random_number = randi() % 3
				print([parent1, parent2] + parent1.family + parent2.family)
				if random_number == 0: #parent1's main color, parent1's spot color, parent2's spot color
					rat_variables = create_rat("kid", parent1.all_colors[randi() % len(parent1.all_colors)], spots_list.pop_at(randi() % len(spots_list)), parent1.all_colors[randi() % len(parent1.all_colors)], spots_list.pop_at(randi() % len(spots_list)), parent2.all_colors[randi() % len(parent2.all_colors)], [parent1, parent2] + parent1.family + parent2.family)
				elif random_number == 1: #parent2's main color, parent1's spot color, parent2's spot color
					rat_variables = create_rat("kid", parent2.all_colors[randi() % len(parent2.all_colors)], spots_list.pop_at(randi() % len(spots_list)), parent2.all_colors[randi() % len(parent2.all_colors)], spots_list.pop_at(randi() % len(spots_list)), parent2.all_colors[randi() % len(parent2.all_colors)], [parent1, parent2] + parent1.family + parent2.family)
				elif random_number == 2: #parent1's main color, parent2's spot color, parent1's spot color
					rat_variables = create_rat("kid", parent1.all_colors[randi() % len(parent1.all_colors)], spots_list.pop_at(randi() % len(spots_list)), parent2.all_colors[randi() % len(parent2.all_colors)], spots_list.pop_at(randi() % len(spots_list)), parent1.all_colors[randi() % len(parent1.all_colors)], [parent1, parent2] + parent1.family + parent2.family)
				#Messages() Text
				var messages_list = [parent1.nickname + ' has just given birth!', 'It\'s too early in this rat\'s life to know how powerful its dice will be.']
				$UI/Output.call_deferred("set_text", messages_list)
				yield($UI/Output, "messages_empty") #Wait for messages() to signal that there's no more messages to display
				#After Messages() Text
	#			$UI/Output.append_bbcode('Name: ' + rat_variables[0] + '\n')
	#			$UI/Output.append_bbcode('Likes: ' + PoolStringArray(likes).join(", ") + '\n')
	#			$UI/Output.append_bbcode('Dislikes: ' + PoolStringArray(dislikes).join(", "))
				$UI/Output.push_color(normal_font)
				$UI/Output.push_meta(["event_outcome", rat_variables[0] + " begins checking out the new space. " + parent1.nickname + " and " + parent2.nickname + " look proudly at their kid.", "add_rat"])
				$UI/Output.append_bbcode('[center]Congratulations! Welcome to the family.')
				$UI/Output.push_meta(["event_outcome", rat_variables[0] + "'s parents look on, horrified, as you take their newborn child and release them into the desolate land outside. " + rat_variables[0] + " looks very sad and confused.", ["decrease_happiness", parent1, 5], ["decrease_happiness", parent2, 5]])
				$UI/Output.append_bbcode('[center]Yeah... I\'m kicking the kid out.')
		else:
			events()
	elif event_number == 2: #Fleas Event - rat gets fleas or catches fleas from another rat, player decides to give them a bath or let it be
		var rats_without_fleas = get_tree().get_nodes_in_group("rats") #Creates a list of all rats on screen
		var fleas_rat = null
		for rat in rats_without_fleas:
			for condition in rat.conditions:
				if condition[0] == "fleas":
					fleas_rat = rat #Make the fleas_rat be a rat instance with fleas instead of null
					rats_without_fleas.erase(rat)
		if rats_without_fleas.size() != 0:
			#Messages() Text
			var rat = rats_without_fleas.pop_at(randi() % len(rats_without_fleas)) #Picks a random rat, var rat is the node of the random rat
			#rich_text_nextable = true
			if fleas_rat == null: #If no rats have fleas yet
				$UI/Output.call_deferred("set_text", [rat.nickname + ' has been rubbing against rocks and seems very agitated.', 'Upon further inspection, ' + rat.nickname + ' seems to be suffering from fleas.', 'How should the fleas be dealt with?'])
			else: #If at least 1 rat(but not all of the rats) has fleas already
				$UI/Output.call_deferred("set_text", [fleas_rat.nickname + ' has transfered their fleas to ' + rat.nickname + '. ', rat.nickname + ' is now suffering from fleas.', 'How should the fleas be dealt with?'])
			yield($UI/Output, "messages_empty") #Wait for messages() to signal that there's no more messages to display
			#Choices
			print("returned")
			$UI/Output.push_color(normal_font)
			if "baths" in rat.dislikes:
				$UI/Output.push_meta(["event_outcome", rat.nickname + " scowles at you the entire time you are giving them a bath. They refuse to talk to you for the rest of the day, but at least they don't have fleas anymore.", ["decrease_happiness", rat, 2]])
			elif "baths" in rat.likes:
				$UI/Output.push_meta(["event_outcome", rat.nickname + " has an absolute ball in the bath, and the fleas are all gone.", ["increase_happiness", rat, 5]])
			else:
				$UI/Output.push_meta(["event_outcome", rat.nickname + " looks very clean and begins checking their reflection out in a bucket of water.", ["increase_happiness", rat, 2]])
			$UI/Output.append_bbcode('[center]Give ' + rat.nickname + ' a thorough bath.')
			$UI/Output.push_meta(["event_outcome", rat.nickname + " is itchy and uncomfortable.", ["add_condition", rat, "fleas"]])
			$UI/Output.append_bbcode('[center]Let the fleas go away naturally.')
			
		else: #Recall events() if ALL rats already have fleas
			events()
	elif event_number == 3: #Bees Event - rat gets stung by a bee, player decides to retaliate or get the stinger out
		var rat = get_tree().get_nodes_in_group("rats").pop_at(randi() % current_population - 1) #Creates a list of all rats on screen
		decrease_happiness(rat, 4)
		#Messages() Text
		$UI/Output.call_deferred("set_text", [rat.nickname + ' sniffed a flower with a bee in it, and got stung on the nose!', 'How will you handle the bee situation?'])
		yield($UI/Output, "messages_empty") #Wait for messages() to signal that there's no more messages to display
		#Choices
		print("returned")
		$UI/Output.push_color(normal_font)
		$UI/Output.push_meta(["event_outcome", "You got 3 honeycombs, but " + rat.nickname + " will need to rest tomorrow.", ["add_item", "honeycomb", 3], ["add_condition", rat, "rest", 0]])
		$UI/Output.append_bbcode('[center]Destroy the hive.')
		$UI/Output.push_meta(["event_outcome", rat.nickname + " is thankful that you got the stinger out before the poison could spread.", ["increase_happiness", rat, 2], ["add_condition", rat, "bee"]])
		$UI/Output.append_bbcode('[center]Get the stinger out.')
	elif event_number == 4: #Baker Event - a baker stumbles upon the sanctuary, and they want one/some of your items in return for one of their baked goods
		if inventory.size() > 0:
			var all_needed_items = ["apple", "blueberry", "orange", "pear"]
			var pastry_types = ["pie", "muffin", "donut"]
			var item_needed
			for item in inventory:
				if inventory[item]["base item"] in all_needed_items:
					item_needed = item
					break
			if item_needed == null:
				events()
			else:
				pastry_types.shuffle()
				var pastry_type = pastry_types[0]
				
				#Messages() Text
				$UI/Output.call_deferred("set_text", ["A local baker has stumbled upon your rat sanctuary.", "They explain that they are in need of " + article(item_needed) + " " + inventory[item_needed]["base item"] + " to make " + inventory[item_needed]["base item"] + " " + pastry_type + 's, and will give you one of the ' +  inventory[item_needed]["base item"] + ' ' + pastry_type + 's in return.', 'How will you respond?'])
				yield($UI/Output, "messages_empty") #Wait for messages() to signal that there's no more messages to display
				#Choices
				$UI/Output.push_color(normal_font)
				$UI/Output.push_meta(["event_outcome", "The baker profoundly thanks you for the " + inventory[item_needed]["base item"] + ", and gives you " + article(item_needed) + " " + inventory[item_needed]["base item"] + ' ' + pastry_type + " as promised.", ["remove_item", inventory[item_needed]["base item"], 1, inventory[item_needed].get("color name")], ["add_item", pastry_type, 1, item_needed]])
				$UI/Output.append_bbcode('[center]Make the trade.')
				$UI/Output.push_meta(["event_outcome", "The baker looks disappointed, but leaves without a fuss."])
				$UI/Output.append_bbcode('[center]Decline the baker\'s request.')
		else:
			events()
	elif event_number == 5: #Storm Event - a rainstorm scares the rats and decreases every rat's happiness by 6
		if inventory.size() > 0:
			var lost_item = inventory.keys()[randi() % inventory.size()]
			var lost_item_array = invent.remove_item(inventory[lost_item]["base item"], 1, inventory[lost_item].get("color name"))
			decrease_happiness(get_tree().get_nodes_in_group("rats"), 5)
			
			#Messages() Text
			if current_population > 1:
				$UI/Output.call_deferred("set_text", ['During the night, a massive thunderstorm shook up the sanctuary.', 'The rats have become very frightened, and some of your items have been misplaced.', 'What will you focus on in the aftermath of the storm?'])
			else:
				$UI/Output.call_deferred("set_text", ['During the night, a massive thunderstorm shook up the sanctuary.', get_tree().get_nodes_in_group("rats")[0].nickname + ' is very frightened, and some of your items have been misplaced.', 'What will you focus on in the aftermath of the storm?'])
			yield($UI/Output, "messages_empty") #Wait for messages() to signal that there's no more messages to display
			#Choices
			print("returned")
			$UI/Output.push_color(normal_font)
			if current_population > 1:
				$UI/Output.push_meta(["event_outcome", "The rats feel a little bit better.", ["increase_happiness", get_tree().get_nodes_in_group("rats"), 2]])
				$UI/Output.append_bbcode('[center]Comfort the rats.')
			else:
				$UI/Output.push_meta(["event_outcome", get_tree().get_nodes_in_group("rats")[0].nickname + " feels a little bit better.", ["increase_happiness", get_tree().get_nodes_in_group("rats"), 2]])
				$UI/Output.append_bbcode("[center]Comfort " + get_tree().get_nodes_in_group("rats")[0].nickname + ".")
			$UI/Output.push_meta(["event_outcome", "You were able to find your " + lost_item + ".", ["add_item", lost_item_array[0], lost_item_array[1], lost_item_array[2]]])
			$UI/Output.append_bbcode("[center]Search for lost items.")
		else:
			events()
	elif event_number == 6: #Rat wants a name change
		var all_rats = get_tree().get_nodes_in_group("rats") #Create list of all rats on screen, pop a rat from list at random
		var rat = all_rats.pop_at(randi() % all_rats.size())
		if rat.name_changed == false:
			var name_prefixes = ["Duke", "Captain", "Lord"]
			var name_suffixes = ["wart", "paws"]
			var new_name
			if randi() % 6 > 0: #Completely new name
				new_name = rat_names[randi() % len(rat_names)]
			else: #New prefix or suffix
				if randi() % 1 > 0:
					new_name = name_prefixes[randi() % name_prefixes.size()] + " " + rat.nickname
				else:
					new_name = rat.nickname + name_suffixes[randi() % name_suffixes.size()]
			if new_name == rat.nickname:
				events()
			var reasons = [" thinks that the name \"" + new_name + "\" would make them seem cooler.", " thinks that the name \"" + new_name + "\" has a much better ring to it than \"" + rat.nickname + "\".", " thinks that the name \"" + new_name + "\" fits them much better.", " thinks that the name \"" + rat.nickname + "\" doesn't rhyme with anything fun, which is a big problem. They think \"" + new_name + "\" has much better rhyming potential."]
			var reason = reasons[randi() % len(reasons)]
			#Messages() Text
			$UI/Output.call_deferred("set_text", ["After much deliberation, " + rat.nickname + " expresses the desire to change their name.", rat.nickname + reason, "How will you respond?"])
			yield($UI/Output, "messages_empty") #Wait for messages() to signal that there's no more messages to display
			#Choices
			$UI/Output.push_color(normal_font)
			$UI/Output.push_meta(["event_outcome", new_name + " wiggles with joy.", ["change_trait", rat, "nickname", new_name], ["increase_happiness", rat, 5]])
			$UI/Output.append_bbcode('[center]Sure!')
			$UI/Output.push_meta(["event_outcome", rat.nickname + " sighs and scurries off.", ["decrease_happiness", rat, 4]])
			$UI/Output.append_bbcode("[center]No, " + rat.nickname + " suits you best.")
		else:
			events()
	elif event_number == 7: #Bad Accessory Event - a rat is wearing an accessory that another rat hates OR a rat hates the accessory they are wearing
		if current_population >= 2:
			var scared_rat = null
			var rat_with = null
			var accessory = null
			var accessory_identifiers = []
			var dislike = null
			var rats = get_tree().get_nodes_in_group("rats")
			for rat in rats:
				if rat.get_node("Accessory").visible or rat.get_node("HeadAccessory").visible: #Rat has an accessory/head accessory
					for i in items: #Find the sprite sheet of the accessory from the items dictionary
						if items[i]["identifiers"][0] == "accessory" or items[i]["identifiers"][0] == "head accessory":
							if items[i]["sprite sheet"] == rat.get_node("Accessory").texture.resource_path or items[i]["sprite sheet"] == rat.get_node("HeadAccessory").texture.resource_path: 
								rat_with = rat #Set the rat with the accessory
								accessory = i #Set the base accessory
								accessory_identifiers = [i] + items[i]["identifiers"].slice(1, -1)
								break #Stop looking in the items dictionary
				for rat2 in rats:
					for d in rat2.dislikes: #Iterate through all the rat's dislikes
						if d in accessory_identifiers: #If the dislike is in the accessory's identifiers
							dislike = d
							scared_rat = rat2
							break
				if rat_with != null and scared_rat != null:
					break #Leave loop when/if both rats are found to prevent unnecessary iterations
			if rat_with == null or scared_rat == null: #Recall events() if no rats are bothered by the rat's accessory
				events()
			else: #Messages() Text
				$UI/Output.call_deferred("set_text", [scared_rat.nickname + ", who hates " + dislike + ", is very upset by the " + accessory + " that " + rat_with.nickname + " is wearing.", scared_rat.nickname + " will continue to loose happiness daily unless " + rat_with.nickname + " removes the " + accessory + "."])
				yield($UI/Output, "messages_empty") #Wait for messages() to signal that there's no more messages to display
				#After Messages() Text
				$UI/Output.push_color(normal_font)
				$UI/Output.push_meta(["event_outcome", scared_rat.nickname + " is relieved, but " + rat_with.nickname + " is very annoyed and wants their " + accessory + " back.", ["increase_happiness", scared_rat, 2], ["decrease_happiness", rat_with, 5]])
				$UI/Output.append_bbcode("[center]Take the " + accessory + " from " + rat_with.nickname + ".")
				$UI/Output.push_meta(["event_outcome", scared_rat.nickname + " is annoyed by your neutral stance.", ["decrease_happiness", scared_rat, 1], ["add_condition", scared_rat, "bad accessory", rat_with, accessory, items[accessory]["sprite sheet"]]])
				$UI/Output.append_bbcode("[center]Don\'t get involved.")
		else:
			events()
	elif event_number == 8: #Rebelious Phase event - a rat want to get an accessory and you have to decide to pay for it or not
		var rats = get_tree().get_nodes_in_group("rats")
		var random_rat = rats[randi() % len(rats)]
		var accessories_choice = items[randi() % len(items)] #CHANGE - this won't work now with the updated items list system
		
		$UI/Output.append_bbcode('[center]' + random_rat + ' is experimenting with their style, and requests ' + accessories_choice + '.[/center]')
		$UI/Output.append_bbcode('[center][url=add_accessory]Gladly!.[/url][/center]')
		$UI/Output.append_bbcode('[center][url=option2]No way.[/url][/center]')
	elif event_number == 9: #Hungry event - a rat that's been alive for over 5 days and still hasn't been given food is very hungry, and you must pick food for them that fits their likes and dilikes
		var rats = get_tree().get_nodes_in_group("rats")
		var random_rat = rats[randi() % len(rats)]
		
		$UI/Output.append_bbcode('[center]' + random_rat + ' is feeling quite peckish and would like something to eat.[/center]')
	elif event_number == 10: #Wizard event - chance to find/get gifted/have the potential to get a wizard hat which can then be given to a rat
		pass

func event_outcome(outcome_text): #Updates OutputRichText with the outcome of the player's event, does what needs to be done depending on which event and player's choice, then calls main_options() function
	#Messages() Text
	$UI/Output.call_deferred("set_text", [outcome_text])
	yield($UI/Output, "messages_empty") #Wait for messages() to signal that there's no more messages to display
	#Choices
	$UI/Output.push_color(normal_font)
	$UI/Output.push_meta(["leave", "wake_up"])
	$UI/Output.append_bbcode('[center]Tomorrow is a new day.')

func increase_happiness(rat_node, potential_happiness: int):
	if rat_node is Array: #Multiple rats
		for r in rat_node:
			r.happiness = clamp(r.happiness + potential_happiness, 0, 10) #Ensures rat's happiness var is in the proper range
		show_rat(rat_node[0])
		rat_node = rat_node[0]
	else: #Just one rat
		show_rat(rat_node)
		if rat_node.happiness + potential_happiness <= 10:
			$UI/Updates.new_update(rat_node.nickname + " gained " + String(clamp(rat_node.happiness + potential_happiness, 0, 10) - rat_node.happiness) + " happiness")
		rat_node.happiness = clamp(rat_node.happiness + potential_happiness, 0, 10) #Ensures rat's happiness var is in the proper range
		#Animate the happiness bar updating
	var tween = get_tree().create_tween()
	tween.tween_property($UI/HappinessProgress, "value", rat_node.happiness, .25)
	$UI/HappinessLabel.text = String(rat_node.happiness * 10) + "% Happiness"
	print("Happiness increased by " + String(potential_happiness))

func decrease_happiness(rat_node, potential_happiness: int):
	if rat_node is Array: #Multiple rats
		for r in rat_node:
			r.happiness = clamp(r.happiness - potential_happiness, 0, 10) #Ensures rat's happiness var is in the proper range
		show_rat(rat_node[0])
		rat_node = rat_node[0]
	else: #Just one rat
		show_rat(rat_node)
		rat_node.happiness = clamp(rat_node.happiness - potential_happiness, 0, 10) #Ensures rat's happiness var is in the proper range
		#Animate the happiness bar updating
	var tween = get_tree().create_tween()
	tween.tween_property($UI/HappinessProgress, "value", rat_node.happiness, .25)
	$UI/HappinessLabel.text = String(rat_node.happiness * 10) + "% Happiness"
	print("Happiness decreased by " + String(potential_happiness))

func show_rat(rat):
	current_bio_index = get_tree().get_nodes_in_group("rats").find(rat) - 1 #Show the rat by manually pressing the next rat button via code
	_on_NextRat_pressed()

func create_item(base_item, quantity, col_name = null): #params: 
	if !items[base_item].has("color list"): #Base item doesn't have a color list
		print("Base item doesn't have a color list")
		return [base_item, quantity, null]
	elif col_name != null: #Base item has a color list, and the color is given
		print("Base item has a color list, and a color is given")
		return [base_item, quantity, col_name]
	else: #Base item has a color list, but no color is given, so a random color will be picked from the item's color list
		print("Base item has a color list, and no color given")
		var color_name = items[base_item]["color list"].keys()[randi() % (items[base_item]["color list"].size())] #color_name is the random color name
		return [base_item, quantity, color_name]

func add_item(base_item, quantity, color_name = null, text = null):
	var floating_item = load("res://FloatingItem.tscn").instance()
	add_child(floating_item)
	if !items[base_item].has("color list"): #Base item doesn't have a color list
		floating_item.play(items[base_item]["image"], "Endless", Vector2(480, 232))
		if text != null: #Display text if given
			$UI/Output.append_bbcode(text + article(base_item) + " " + base_item + '!')
	else: #Base item has a color list
		floating_item.play(items[base_item]["image"], "Endless", Vector2(480, 232), items[base_item]["color list"][color_name])
		if text != null: #Display text if given
			$UI/Output.append_bbcode(text + article(color_name + " " + base_item) + " " + color_name + ' ' + base_item + '!')
	invent.add_item(base_item, quantity, color_name) #Adds item to the inventory

func create_rat(grouping = null, main_color = null, spot_type1 = null, spot_color1 = null, spot_type2 = null, spot_color2 = null, family = []):
	#Set rat's name
	var nickname = rat_names.pop_at(randi() % (len(rat_names) - 1)) #Gets a random name from the list of potential rat names

	#Set likes and dislikes
	all_likes.shuffle()
	likes = []
	dislikes = []
	#Set Likes
	likes.append(all_likes[0]) #Set 1st like
	if randi() % 4 > 0: #Set 2nd like, 3/4% chance
		likes.append(all_likes[1])
	#Set Dislikes
	dislikes.append(all_likes[2]) #Set 1st dislike
	if randi() % 4 > 0: #Set 2nd dislike, 3/4% chance
		dislikes.append(all_likes[3])
	#Set body and spot colors, if they aren't already set
	if main_color == null:
		main_color = colors[randi() % 13]
	if spot_color1 == null and spot_color2 == null:
		#Give rat one spot
		spot_type1 = spot_textures[randi() % 8]
		spot_color1 = colors[randi() % 13]
		if randi() % 9 <= 2: #Give rat two spots
			spot_type2 = spot_textures[randi() % 8]
			if randi() % 2 == 1:
				spot_color2 = colors[(colors.find(main_color) + 1) % 13]
			else:
				spot_color2 = colors[(colors.find(main_color) - 1) % 13]
	#Create the dice
	var dice_uses = (randi() % 2) + 1
	var dice_type = 6
	if current_population == 0: #Dice type can only be 6, and must have 2 uses
		dice_type = 6
		dice_uses = 2
	elif current_population < 4: #Dice type can only be 6, 8, 10
		dice_type = dice_types.keys()[randi() % 3] #dice_type is now an int with the max number, like 6
	else: #Dice type can be 6, 8, 10, 12, 20
		dice_type = dice_types.keys()[randi() % 5] #dice_type is now an int with the max number, like 6
	
	return [nickname, likes, dislikes, grouping, main_color, spot_type1, spot_color1, spot_type2, spot_color2, family, dice_type, dice_uses]

func add_rat(): #Create a new rat instance using the RatClass
	var rat_instance = RatClassNode.instance()
	$YSort.add_child(rat_instance)
	#Connect rat_gui_input() to main
	rat_instance.connect("input_event", self, "rat_gui_input", [rat_instance])
	#Connect the rat's mouse_entered() and mouse_exited() to main script
	rat_instance.connect("mouse_entered", self, "rat_mouse_entered", [rat_instance])
	rat_instance.connect("mouse_exited", self, "rat_mouse_exited", [rat_instance])
	#Checks the grouping and adds rat to the appropriate group
	if rat_variables[3] == "kid": #If the rat to be added is a kid
		rat_instance.scale = Vector2(2,2)
		rat_instance.z_index = -1
		rat_instance.add_to_group("kid rats") #Adds the new rat instance to the group of kid rat instances
	elif rat_variables[3] == "temporary":
		rat_instance.add_to_group("temporary rats") #Adds the new rat instance to the group of temporary rat instances
		rat_instance.add_to_group("adult rats") #Adds the new rat instance to the group of adult rat instances
	else:
		rat_instance.add_to_group("adult rats") #Adds the new rat instance to the group of adult rat instances
	rat_instance.add_to_group("rats") #Adds the new rat instance to the group of all rat instances
	
	rat_instance.nickname = rat_variables[0]
	rat_instance.family = rat_variables[9]
	rat_instance.set_colors(rat_variables[4], rat_variables[5], rat_variables[6], rat_variables[7], rat_variables[8])
	rat_instance.set_likes_and_dislikes(rat_variables[1], rat_variables[2])
	rat_instance.set_location(locations)
	#Add 1 to the current population var
	current_population += 1
	#Show the newly added rat in the info area
	show_rat(rat_instance)
	#Create the dice
	var dice_instance = D6ClassNode.instance()
	$UI/DiceContainer.add_child(dice_instance)
	dice_instance.get_child(0).texture = load(dice_types[rat_variables[10]][0]) #Sets dice's body texture
	dice_instance.get_child(2).texture = load(dice_types[rat_variables[10]][1]) #Sets dice's disabled texture
	dice_instance.get_child(3).texture = load(dice_types[rat_variables[10]][2]) #Sets dice's selected texture
	dice_instance.get_child(0).self_modulate = rat_variables[4] #Sets dice's body color
	dice_instance.get_child(1).self_modulate = rat_variables[6] #Sets dice's number color
	dice_instance.number = rat_variables[10]
	if dice_instance.number == 8:
		dice_instance.get_child(1).position.y -= 5
	elif dice_instance.number == 10 or dice_instance.number == 20:
		dice_instance.get_child(1).position.y -= 3
	dice_instance.get_child(1).frame = dice_instance.number - 1 #Sets dice's number frame to the max number
	dice_instance.uses = rat_variables[11]
	dice_instance.uses_left = rat_variables[11]
	dice_instance.rat = rat_instance
	rat_instance.die = dice_instance
	#Add the new die to the list of all current dice
	current_dice.append(dice_instance)

func add_condition(rat, new_condition, var1 = null, var2 = null, var3 = null): #Adds a new condition to a rat
	if new_condition == "fleas": #Rat has fleas for 3 days
		rat.conditions.append(["fleas", 3])
		var fleas_instance = FleasClassNode.instance()
		fleas_instance.emitting = true
		rat.add_child(fleas_instance)
	elif new_condition == "rest": #Rat must rest for a certain amount of days. var1 = amount of days rat must rest
		rat.conditions.append(["rest", var1])
		rat.die.uses_left = 0
		rat.die.used = true
		rat.die.get_node("DisabledLayer").visible = true
	elif new_condition == "bad accessory": #Rat will loose happiness every day until another rat removes their accessory. var1 = rat with accessory, var2 = String name of the accessory, var3 = texture resourse of the accessory
		rat.conditions.append(["bad accessory", var1, var2, var3])

func change_trait(rat, which_trait, new_trait):
	rat.set(which_trait, new_trait) #Set the variable given in which_trait to be the given new_trait
	if which_trait == "nickname":
		rat.name_changed = true
	show_rat(rat)

#This func is connected to Output and its parameter is the "url" that is defined within brackets before the underlined text
func _on_Output_meta_clicked(function):
	if function is String:
		if function == "north" or function == "east" or function == "west":
			forest(str(function))
		else:
			call(function)
	elif function is Array:
		if function[0] == "event_outcome":
			event_outcome(function[1]) #Calls event_outcome w/ the outcome text
			if len(function) >= 3:
				_on_Output_meta_clicked(function[2]) #Calls first function if given by putting it into the meta clicked funtion
			if len(function) == 4:
				_on_Output_meta_clicked(function[3]) #Calls second function if given by putting it into the meta clicked funtion
		elif function[0] == "leave" and len(function) == 2:
			leave(function[1])
		elif function[0] == "leave" and len(function) == 3:
			leave(function[1], function[2])
		elif function[0] == "roll_dice_setup":
			roll_dice_setup(function[1], function[2], function[3])
		elif function[0] == "add_item":
			invent.callv("add_item", function.slice(1, -1))
		elif function[0] == "remove_item":
			invent.callv("remove_item", function.slice(1, -1))
		else:
			callv(function[0], function.slice(1, -1)) #Assumes first item in list is function name, and the rest are the parameters
	#elif function.substr(0,6) == "outcome":
		#callv("outcome", function.substr(7))

func _on_Output_gui_input(event):
	if event.is_action_released("MOUSE_LEFT"):
		invent.hide_inventory()

#Rat Bio Previous and Next Buttons, which update info displayed in the bio area when the arrow buttons are pressed(or simulated being pressed)
func _on_PreviousRat_pressed():
	current_bio_index -= 1
	if get_tree().has_group("rats"):
		if len(get_tree().get_nodes_in_group("rats")) > 0:
			#Makes the previous rat's spots and accessories invisible
			for n in get_tree().get_nodes_in_group("BioSprites"):
				n.visible = false
			var all_rats = get_tree().get_nodes_in_group("rats")
			if current_bio_index < 0: #If the user tries to press the previous button but they're already at the first rat, it will circle back to the last rat in the all_rats list
				current_bio_index = len(all_rats) - 1
			$UI/Body.material.set('shader_param/modulate', all_rats[current_bio_index].get_node("Body").material.get_shader_param('modulate'))
			$UI/NameLabel.text = all_rats[current_bio_index].nickname
			$UI/RatInfoM/V/LikesLabel.text = "Likes: " + PoolStringArray(all_rats[current_bio_index].likes).join(", ")
			$UI/RatInfoM/V/DislikesLabel.text = "Dislikes: " + PoolStringArray(all_rats[current_bio_index].dislikes).join(", ")
			#Update HappinessProgress and HappinessLabel
			$UI/HappinessProgress.value = all_rats[current_bio_index].happiness
			$UI/HappinessLabel.text = str($UI/HappinessProgress.value * 10) + "% Happiness"
			#Set spot textures and colors
			$UI/Spot1.texture = all_rats[current_bio_index].get_node("Spot1").texture
			$UI/Spot1.self_modulate = all_rats[current_bio_index].get_node("Spot1").self_modulate
			$UI/Spot1.visible = true
			if all_rats[current_bio_index].get_node("Spot2").visible == true:
				$UI/Spot2.texture = all_rats[current_bio_index].get_node("Spot2").texture
				$UI/Spot2.self_modulate = all_rats[current_bio_index].get_node("Spot2").self_modulate
				$UI/Spot2.visible = true
			#Makes any accessories visible
			if all_rats[current_bio_index].get_node("Accessory").visible == true:
				$UI/Accessory.texture = all_rats[current_bio_index].get_node("Accessory").texture
				$UI/Accessory.material.set('shader_param/modulate', all_rats[current_bio_index].get_node("Accessory").material.get_shader_param('modulate'))
				$UI/Accessory.visible = true
			if all_rats[current_bio_index].get_node("HeadAccessory").visible == true:
				$UI/HeadAccessory.texture = all_rats[current_bio_index].get_node("HeadAccessory").texture
				$UI/HeadAccessory.material.set('shader_param/modulate', all_rats[current_bio_index].get_node("HeadAccessory").material.get_shader_param('modulate'))
				$UI/HeadAccessory.visible = true

func _on_NextRat_pressed():
	current_bio_index += 1
	if get_tree().has_group("rats"):
		if len(get_tree().get_nodes_in_group("rats")) > 0:
			#Makes the previous rat's spots invisible
			for n in get_tree().get_nodes_in_group("BioSprites"):
				n.visible = false
			var all_rats = get_tree().get_nodes_in_group("rats")
			#If the list isn't at its max index, it will show the bio of the next rat in the list of rats in the group "rats"
			if current_bio_index >= len(all_rats): #If the user tries to press the next button but they're already at the last rat, it will circle back to the first rat
				current_bio_index = 0
			$UI/Body.material.set('shader_param/modulate', all_rats[current_bio_index].get_node("Body").material.get_shader_param('modulate'))
			$UI/NameLabel.text = all_rats[current_bio_index].nickname
			$UI/RatInfoM/V/LikesLabel.text = "Likes: " + PoolStringArray(all_rats[current_bio_index].likes).join(", ")
			$UI/RatInfoM/V/DislikesLabel.text = "Dislikes: " + PoolStringArray(all_rats[current_bio_index].dislikes).join(", ")
			#Update HappinessProgress and HappinessLabel
			$UI/HappinessProgress.value = all_rats[current_bio_index].happiness
			$UI/HappinessLabel.text = str($UI/HappinessProgress.value * 10) + "% Happiness"
			#Set spot textures and colors
			$UI/Spot1.texture = all_rats[current_bio_index].get_node("Spot1").texture
			$UI/Spot1.self_modulate = all_rats[current_bio_index].get_node("Spot1").self_modulate
			$UI/Spot1.visible = true
			if all_rats[current_bio_index].get_node("Spot2").visible == true:
				$UI/Spot2.texture = all_rats[current_bio_index].get_node("Spot2").texture
				$UI/Spot2.self_modulate = all_rats[current_bio_index].get_node("Spot2").self_modulate
				$UI/Spot2.visible = true
			#Makes any accessories visible
			if all_rats[current_bio_index].get_node("Accessory").visible == true:
				$UI/Accessory.texture = all_rats[current_bio_index].get_node("Accessory").texture
				$UI/Accessory.material.set('shader_param/modulate', all_rats[current_bio_index].get_node("Accessory").material.get_shader_param('modulate'))
				$UI/Accessory.visible = true
			if all_rats[current_bio_index].get_node("HeadAccessory").visible == true:
				$UI/HeadAccessory.texture = all_rats[current_bio_index].get_node("HeadAccessory").texture
				$UI/HeadAccessory.material.set('shader_param/modulate', all_rats[current_bio_index].get_node("HeadAccessory").material.get_shader_param('modulate'))
				$UI/HeadAccessory.visible = true

#Utility function for returning the correct definite article for a given string
func article(string: String): 
	print(string)
	if "earrings" in string or "sneakers" in string:
		return "a pair of"
	elif string[0] in "aeiou":
		return "an"
	else:
		return "a"
