extends Node2D

@export var speed = 40
var mountains: Array = []

func _enter_tree() -> void:
	var letters = ["A", "B", "C", "D"]
	for letter in letters:
		mountains.append(find_child("Mountains%s" % letter))

func _physics_process(delta: float) -> void:
	for mountain in mountains:
		mountain.position[0] -= delta * speed
		if (mountain.position[0] <= -285.75):
			mountain.position[0] = 590.75
