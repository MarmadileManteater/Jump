extends Node2D

@export var speed = 10
var trees: Array = []

func _enter_tree() -> void:
	var letters = ["A", "B", "C", "D"]
	for letter in letters:
		trees.append(find_child("Trees%s" % letter))

func _physics_process(delta: float) -> void:
	for tree in trees:
		tree.position[0] -= delta * speed
		if (tree.position[0] <= -276.0):
			tree.position[0] = 624.0
