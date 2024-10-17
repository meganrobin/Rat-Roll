extends Control

var TooltipClass = preload("res://Tooltip.tscn")
var rat #the rat instance that's connected to this dice#
var number = 6
var uses_left = 1
var uses = 1
var modifier = null
var used = false
var clickable = false
var selected = false
var roll_number = 0

func _ready():
	$Number.frame = number - 1
	randomize()

func _on_D6Class_gui_input(event):
	#Selects or deselects die#
	if event.is_action_pressed("MOUSE_LEFT") and clickable:
		if used == false:
			if selected == false:
				selected = true
				$SelectedHighlight.visible = true
				print("Dice selected")
			else:
				selected = false
				$SelectedHighlight.visible = false
				print("Dice deselected")

func roll():
	$SelectedHighlight.visible = false
	uses_left -= 1
	if uses_left == 0:
		used = true
	$Tween.interpolate_property($Number, "frame",
			0, number-1, number * .025,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$AnimationPlayer.play("Roll")
	roll_number = (randi() % number) + 1
	return roll_number

func flash_animation(): #Used by Main.gd to play the flash animation to show the player that the dice are clickable
	$AnimationPlayer.play("Flash")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Roll":
		$Number.frame = roll_number - 1
		$AnimationPlayer.play("Result")

func _on_D6Class_mouse_entered(): #Populate tooltip data and show tooltip
	var tooltip_instance = TooltipClass.instance()
	add_child(tooltip_instance)
	tooltip_instance.populate_dice_data(rat.nickname, number, uses_left, uses, modifier)
	tooltip_instance.show()

func _on_D6Class_mouse_exited():
	get_node("Tooltip").free()
	
