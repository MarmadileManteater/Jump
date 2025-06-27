extends Control

@export var link = ""

func _enter_tree() -> void:
	connect("gui_input", _on_gui_input)

func _on_gui_input(event: InputEvent):
	if (event is InputEventMouseButton
	or event is InputEventScreenTouch):
		if (event.is_pressed()):
			OS.shell_open(link)
