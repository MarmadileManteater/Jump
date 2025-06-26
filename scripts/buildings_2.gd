extends Node2D

@export var speed = 20
@export	var letters = ["A", "B", "C", "D", "E"]
@export var left_end = -257.75
@export var right_end = 342.0
@export var range_start = -1
@export var range_end = 2
var base_building: Sprite2D
var buildings: Array = []
var has_emitted_rotation = false
signal full_rotation

func _enter_tree() -> void:

	for letter in letters:
		for i in range(range_start, range_end):
			var building = find_child("Buildings %s%d" % [ letter, i ])
			if (building != null):
				buildings.append(building)
	base_building = find_child("Buildings A0")

func _physics_process(delta: float) -> void:
	for building in buildings:
		building.position[0] -= delta * speed
		if (building.position[0] <= left_end):
			building.position[0] = right_end
			if (building == base_building):
				has_emitted_rotation = false
	if (!has_emitted_rotation):
		if (base_building.position.x <= 70 + 5 and base_building.position.x >= 70 - 5):
			has_emitted_rotation = true
			emit_signal("full_rotation")
