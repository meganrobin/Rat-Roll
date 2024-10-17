extends Sprite

func _ready():
	pass
	
func play(image, anim, coords, color = Color(1, 1, 1)):
	texture = load(image)
	position = coords
	material.set('shader_param/modulate', color) #Set the shader modulate color to the given color, or white if the item doesn't have a color
	
	var sparkles = load("res://Sparkles.tscn").instance() #Add a sparkles instance and play the sparkles animation
	add_child(sparkles)
	sparkles.get_node("AnimationPlayer").play("Sparkle")
	$AnimationPlayer.play(anim)
