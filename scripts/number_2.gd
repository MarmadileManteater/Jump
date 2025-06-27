extends Node2D

const Background = preload("res://scripts/background.gd")
const MultiDigitNumber = preload("res://scripts/multi_digit_number.gd")

var food_sprites = ["apple", "pizza", "ice cream", "bread", "soda"]

var parallax: Background
var score: MultiDigitNumber
var final_score_label: Control
var high_score_label: Node2D
var food_spawners: Array = []
var enemy_spawners: Array = []
var foods: Array = []
var food: Node2D
var enemy: Node2D
var gui: CanvasLayer
var rotated_times = 0
signal final_score
signal reload_scene

func _enter_tree() -> void:
	parallax = find_child("Parallax")
	gui = find_child("GUI")
	score = gui.find_child("Score")
	final_score_label = gui.find_child("Final Score Label")
	high_score_label = final_score_label.find_child("High Score Label Container")
	food_spawners = find_children("FoodSpawner*")
	enemy_spawners = find_children("EnemySpawner*")
	food = find_child("Food")
	enemy = find_child("Enemy")
	

func _on_progression_timer_timeout() -> void:
	if (parallax.player.alive):
		if (parallax.speed < 4):
			parallax.set_speed(parallax.speed + 0.1)

func _on_player_score(value: int) -> void:
	score.set_number(score.number + value)

func _on_buildings_1_full_rotation() -> void:
	# prevents food spawns from being seen by player
	while len(foods) != 0:
		foods.pop_back().queue_free()
	
	var food_spawners_list = food_spawners.duplicate()
	for i in range(0, 6):
		var new_food: Node2D = food.duplicate()
		new_food.position = Vector2(0, 0)
		var animated_node = new_food.get_children()[0].get_children()[0].get_children()[0]
		animated_node.animation = food_sprites[randi() % len(food_sprites)]
		foods.append(new_food)
		var spawner_index = randi() % len(food_spawners_list)
		var spawner = food_spawners_list[spawner_index]
		spawner.add_child(new_food)
		food_spawners_list.remove_at(spawner_index)
	if (rotated_times > 0):
		var enemy_spawners_list = enemy_spawners.duplicate()
		for i in range(0, 1):
			var new_enemy = enemy.duplicate()
			var animation_player: AnimationPlayer = new_enemy.get_children()[-1]
			animation_player.speed_scale = parallax.speed * 0.65
			var spawner_index = randi() % len(enemy_spawners_list)
			enemy_spawners_list[spawner_index].add_child(new_enemy)
			new_enemy.visible = true
			animation_player.play()
	rotated_times += 1

func _on_reset_timer_timeout() -> void:
	score.anchor_left = 0.5
	score.anchor_right = 0.5
	score.anchor_bottom = 0.5
	score.anchor_top = 0.5
	score.position.y += 190
	final_score_label.visible = true
	emit_signal("final_score", score.number)


func _on_high_score() -> void:
	high_score_label.visible = true
