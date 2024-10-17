extends Node2D

func _ready():
	$Fireflies.emitting = true
	#$AnimationPlayer.play("Float")

func _on_StartButton_pressed():
	get_tree().change_scene("res://Main.tscn")
