extends CanvasLayer

signal back_pressed

func _on_back_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept") 
	or event is InputEventMouseButton
	or event is InputEventScreenTouch):
		if (event.is_pressed()):
			emit_signal("back_pressed")
