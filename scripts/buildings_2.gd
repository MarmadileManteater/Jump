extends Node2D

@export var speed = 20
@export	var letters = ["A", "B", "C", "D", "E"]
@export var left_end = -257.75
@export var right_end = 342.0
@export var range_start = -1
@export var range_end = 2
var buildings: Array = []

func _enter_tree() -> void:

	for letter in letters:
		for i in range(range_start, range_end):
			print("Buildings %s%d" % [ letter, i ])
			print(find_child("Buildings %s%d" % [ letter, i ]))
			buildings.append(find_child("Buildings %s%d" % [ letter, i ]))

func _physics_process(delta: float) -> void:
	for building in buildings:
		building.position[0] -= delta * speed
		if (building.position[0] <= left_end):
			building.position[0] = right_end
