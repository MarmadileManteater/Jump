extends Node2D

const Background = preload("res://scripts/background.gd")
const MultiDigitNumber = preload("res://scripts/multi_digit_number.gd")

var food_sprites = ["apple", "pizza", "ice cream", "bread", "soda"]

var parallax: Background
var score: MultiDigitNumber
var spawners: Array = []
var foods: Array = []
var food: Node2D

func _enter_tree() -> void:
	parallax = find_child("Parallax")
	score = find_child("GUI").find_child("Score")
	spawners = find_children("FoodSpawner*")
	food = find_child("Food")

func _on_progression_timer_timeout() -> void:
	if (parallax.speed < 4):
		parallax.set_speed(parallax.speed + 0.1)

func _on_player_score(value: int) -> void:
	score.set_number(score.number + value)

func _on_buildings_1_full_rotation() -> void:
	# prevents food spawns from being seen by player
	while len(foods) != 0:
		foods.pop_back().queue_free()
	
	var spawners_list = spawners.duplicate()
	for i in range(0, 6):
		var new_food: Node2D = food.duplicate()
		new_food.position = Vector2(0, 0)
		var animated_node = new_food.get_children()[0].get_children()[0].get_children()[0]
		animated_node.animation = food_sprites[randi() % len(food_sprites)]
		foods.append(new_food)
		var spawner_index = randi() % len(spawners_list)
		var spawner = spawners_list[spawner_index]
		spawner.add_child(new_food)
		spawners_list.remove_at(spawner_index)
