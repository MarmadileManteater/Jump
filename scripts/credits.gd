extends Node2D

var children: Array
var active = true

func _enter_tree() -> void:
	children = get_children()

func _physics_process(delta: float) -> void:
	if (active):
		for child in children:
			child.position.y -= 2
			if (child.position.y < -750):
				child.position.y = 2655.0
