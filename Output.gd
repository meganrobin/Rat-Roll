extends RichTextLabel
signal next_message #Defines the next_message signal
signal messages_empty #Defines the messages empty signal
onready var messages_list = []

func set_text(messages):
	messages_list = messages
	messages()

func _on_Output_gui_input(event):
	if event.is_action_released("MOUSE_LEFT"):
		if percent_visible < 1: #Skip
			percent_visible = 1
			$Tween.remove_all()
			$Tween.emit_signal("tween_all_completed")
		else: #Next message
			emit_signal("next_message") #Emit signal to signify that there are no more messages to display and whatever function was going on in Main can now continue("messages_empty")
			messages()

func messages():
	if messages_list.size() > 0: #More messages left
		clear() #Clears the label
		percent_visible = 0
		var seconds = .03 * messages_list[0].length() #Update var seconds based on how many chars are in the message
		append_bbcode(str(messages_list.pop_front()))
		$Tween.interpolate_property(self, "percent_visible", 0, 1, seconds)
		$Tween.start()
		if messages_list.empty(): #messages_list is now empty
			yield($Tween, "tween_all_completed")
			emit_signal("messages_empty") #Emit signal to signify that there are no more messages to display and whatever function was going on in Main can now continue("messages_empty")
