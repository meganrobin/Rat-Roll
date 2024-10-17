extends VBoxContainer

const UpdateClassNode = preload("res://Update.tscn") #Loads the Rat Class to be able to create new instances of it

func _ready():
	pass
	
func new_update(new_text):
	var update_instance = UpdateClassNode.instance()
	add_child(update_instance)
	update_instance.append_bbcode(new_text)

func _on_Timer_timeout():
	if get_child_count() > 1:
		get_child(1).queue_free()
