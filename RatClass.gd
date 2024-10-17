extends KinematicBody2D

#Movement Vairables
enum {
	IDLE,
	IDLE_REACH,
	LOOK,
	TAIL_OUT,
	TAIL_FLICK,
	NEW_DIR,
	MOVE,
	RUN,
	EAT,
	ITEM,
	SLEEP,
	SHAKE
}
var speed = 60
var current_state = IDLE
var dir = Vector2.RIGHT

#Contasnt Variables
var items = Global.items
onready var love_reaction = preload("res://art/love_reaction.png")
onready var hate_reaction = preload("res://art/hate_reaction.png")
onready var like_reaction = preload("res://art/like_reaction.png")
onready var body = preload("res://art/sprite_sheets/rat/body.png")
onready var body_blink = preload("res://art/sprite_sheets/rat/body_blink.png")

#Other Variables, which will be changed depending on instance
var location
var die
var name_changed = false #True if and only if rat has had a different name
var nickname = ""
var all_colors = [] #List of all the Color() variables used in this rat
var likes = []
var dislikes = []
var personality
var happiness = 0
var has_food = false
var has_item = false
var days_alive = 0
var conditions = [] #List[String, Int] where condition[0][0] is the name of the condition and [0][1] is the amount of days until it goes away
var family = [] #List of family members

func _ready():
	randomize()

func set_colors(main_color, spot_type1, spot_color1, spot_type2 = null, spot_color2 = null): #Params: Color(), String, Color(), String, Color()
	all_colors += [main_color, spot_color1]
	#Set body color
	$Body.material.set('shader_param/modulate', main_color)
	#Set Spot1 texture and color
	$Spot1.texture = load(spot_type1)
	$Spot1.self_modulate = spot_color1
	$Spot1.visible = true
	if spot_type2 != null: #Set Spot2 texture and color, if given
		all_colors.append(spot_color2)
		$Spot2.texture = load(spot_type2)
		$Spot2.self_modulate = spot_color2
		$Spot2.visible = true

func set_location(locations):
	for i in locations:
		if i[2] == false and $Body.visible == false: #if the location isn't being used by another rat and the current rat isn't visible#
			position = i[1]
			i[2] = true
			location = i[0]
			$Body.visible = true

func set_personality(new_personality):
	personality = new_personality

func set_likes_and_dislikes(new_likes, new_dislikes):
	likes = new_likes
	dislikes = new_dislikes

func reaction(reaction): #reaction param holds a string w/ the rat's reaction(either "love", "hate", or "like")
	#Play the correct reaction animation 
	if reaction == "like":
		$Reaction.texture = like_reaction
		$ReactionAnimationPlayer.play("Arrow In")
	elif reaction == "love":
		$Reaction.texture = love_reaction
		$ReactionAnimationPlayer.play("Arrow In")
	elif reaction == "hate":
		$Reaction.texture = hate_reaction
		$ReactionAnimationPlayer.play("Arrow In")
		$Timer.start(1.8)
		current_state = 11 #Makes rat go into SHAKE state
		has_food = false #Ensures rat won't keep eating the food

func highlight():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	$BodyOutline.visible = true
	$HeadAccessoryOutline.visible = true

func unhighlight():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	$BodyOutline.visible = false
	$HeadAccessoryOutline.visible = false

func gift(item): #params: item = an item node
	unhighlight()
	#Adds the item in the correct way depending on the item's type
	if items[item.base_item]["identifiers"][0] == "food":
		$Food.texture = load(items[item.base_item]["image"])
		$Crumbs.color = items[item.base_item]["crumb color"] #Sets the crumbs self_modulate to a color that matches the food that's being eaten
		if item.color_name != null: #Sets shader if the item has a color
			$Food.material.set('shader_param/modulate', items[item.base_item]["color list"][item.color_name]) #This slice gets the (item name with the color - base item name), so that its just the color. Then, it finds the color in the list of color names, and sets the shader "modulate" var equal to that color
		has_food = true
		$Timer.start(3.6)
		current_state = 8 #Makes rat go into EAT state
	elif items[item.base_item]["identifiers"][0] == "head accessory":
		$HeadAccessory.texture = load(items[item.base_item]["sprite sheet"])
		$HeadAccessoryOutline.texture = load(items[item.base_item]["sprite sheet"])
		if item.color_name != null: #Sets shader if the item has a color
			$HeadAccessory.material.set('shader_param/modulate', items[item.base_item]["color list"][item.color_name]) #This slice gets the (item name with the color - base item name), so that its just the color. Then, it finds the color in the list of color names, and sets the shader "modulate" var equal to that color
		$HeadAccessory.visible = true
	elif items[item.base_item]["identifiers"][0] == "accessory":
		$Accessory.texture = load(items[item.base_item]["sprite sheet"])
		if item.color_name != null: #Sets shader if the item has a color
			$Accessory.material.set('shader_param/modulate', items[item.base_item]["color list"][item.color_name]) #This slice gets the (item name with the color - base item name), so that its just the color. Then, it finds the color in the list of color names, and sets the shader "modulate" var equal to that color
		$Accessory.visible = true
	elif items[item.base_item]["identifiers"][0] == "holdable": #Sets shader if the item has a color
		$Item.texture = load(items[item.base_item]["image"])
		if item.color_name != null:
			$Item.material.set('shader_param/modulate', items[item.base_item]["color list"][item.color_name]) #This slice gets the (item name with the color - base item name), so that its just the color. Then, it finds the color in the list of color names, and sets the shader "modulate" var equal to that color
		has_item = true
		current_state = 9 #Makes rat go into ITEM state
	#Check item's base_item against rat's likes and dislikes
	if item.base_item in likes or item.base_item + "s" in likes or item.color_name in likes: #Change the texts to be different depending on both 1. what type of item you give and 2. how much the rat likes it
		reaction("love")
		return "love"
	elif item.base_item in dislikes or item.base_item + "s" in dislikes or item.color_name in dislikes:
		reaction("hate")
		return "hate"
	#Check each of item's identifiers against rat's likes and dislikes
	for i in items[item.base_item]["identifiers"]:
		if i in likes:
			reaction("love")
			return "love"
		elif i in dislikes:
			reaction("hate")
			return "hate"
	#Return "like" if item is neither loved nor hated
	reaction("like")
	return "like"

#Movement Functions
func choose(array):
	array.shuffle()
	return array.front()

func move(delta):
	var rounded_position = position + (dir * speed * delta)
	position = rounded_position.round()
		
	if position.x >= 900: #Rat reached the far right of the screen
		position.x = 886
		dir = Vector2.LEFT
	if position.x <= 60: #Rat reached the far left of the screen
		position.x = 64
		dir = Vector2.RIGHT

func _on_Timer_timeout():
	$Timer.wait_time = choose([1, 1.5, 2, 2.5, 3])
	current_state = choose([IDLE, IDLE_REACH, LOOK, TAIL_OUT, TAIL_FLICK, NEW_DIR, RUN, RUN, RUN, EAT, ITEM])
	
func _process(delta):
	#if location == "location1" or location == "location2" or location == "location3" or location == "location4" or location == "location5": #CHANGE THIS!
	if current_state == 0: #IDLE state
		if dir.x == 1:
			$RatAnimationPlayer.play("Idle Right")
		if dir.x == -1:
			$RatAnimationPlayer.play("Idle Left")
	if current_state == 1: #IDLE_REACH state
		if dir.x == 1:
			$RatAnimationPlayer.play("Idle Reach Right")
		if dir.x == -1:
			$RatAnimationPlayer.play("Idle Reach Left")
	if current_state == 2: #LOOK state
		if dir.x == 1:
			$RatAnimationPlayer.play("Look Right")
		if dir.x == -1:
			$RatAnimationPlayer.play("Look Left")
	if current_state == 3: #TAIL_OUT state
		if dir.x == 1:
			$RatAnimationPlayer.play("Tail Out Right")
		if dir.x == -1:
			$RatAnimationPlayer.play("Tail Out Left")
	if current_state == 4: #TAIL_FLICK state
		if dir.x == 1:
			$RatAnimationPlayer.play("Tail Flick Right")
		if dir.x == -1:
			$RatAnimationPlayer.play("Tail Flick Left")
	if current_state == 5: #NEW_DIR state
		if $RatAnimationPlayer.current_animation == "Walk Right" or $RatAnimationPlayer.current_animation == "Walk Left" or $RatAnimationPlayer.current_animation == "Run Right" or $RatAnimationPlayer.current_animation == "Run Left":
			if dir.x == 1:
				$RatAnimationPlayer.play("Idle Right")
				dir = choose([Vector2.RIGHT, Vector2.LEFT])
			elif dir.x == -1:
				$RatAnimationPlayer.play("Idle Left")
				dir = choose([Vector2.RIGHT, Vector2.LEFT])
		else:
			$RatAnimationPlayer.play($RatAnimationPlayer.get_current_animation())
			dir = choose([Vector2.RIGHT, Vector2.LEFT])
	if current_state == 6: #MOVE state
		speed = 64
		if dir.x == 1:
			$RatAnimationPlayer.play("Walk Right")
		if dir.x == -1:
			$RatAnimationPlayer.play("Walk Left")
	if current_state == 7: #RUN state
		speed = 115
		if dir.x == 1:
			$RatAnimationPlayer.play("Run Right")
		if dir.x == -1:
			$RatAnimationPlayer.play("Run Left")
	if current_state == 8: #EAT state
		if has_food:
			if dir.x == 1:
				$RatAnimationPlayer.play("Eat Right")
			if dir.x == -1:
				$RatAnimationPlayer.play("Eat Left")
		else:
			_on_Timer_timeout()
	if current_state == 9: #ITEM state
		if has_item:
			if dir.x == 1:
				$RatAnimationPlayer.play("Item Right")
			if dir.x == -1:
				$RatAnimationPlayer.play("Item Left")
		else:
			_on_Timer_timeout()
	if current_state == 10: #SLEEP state
		if dir.x == 1:
			$RatAnimationPlayer.play("Lay Down Right")
		if dir.x == -1:
			$RatAnimationPlayer.play("Lay Down Left")
	if current_state == 11: #SLEEP state
		if dir.x == 1:
			$RatAnimationPlayer.play("Shake Right")
		if dir.x == -1:
			$RatAnimationPlayer.play("Shake Right")
	match current_state:
		IDLE:
			pass
		IDLE_REACH:
			pass
		LOOK:
			pass
		TAIL_OUT:
			pass
		TAIL_FLICK:
			pass
		NEW_DIR:
			pass
		MOVE:
			move(delta)
		RUN:
			move(delta)
		EAT:
			pass
		ITEM:
			pass
		SLEEP:
			pass
		SHAKE:
			pass

#func _on_BlinkTimer_timeout():
#	print($Body.texture)
#	if $BlinkTimer.wait_time == 15:
#		print("Blink!")
#		$Body.texture = body
#		$BlinkTimer.wait_time = 0.4
#	else:
#		$Body.texture = body_blink
#		$BlinkTimer.wait_time = 15
