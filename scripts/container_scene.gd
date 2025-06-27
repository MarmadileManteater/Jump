extends Node2D

const root_scene = preload("res://scenes/number_2.tscn")
const credits_scene = preload("res://scenes/credits.tscn")
const Root = preload("res://scripts/number_2.gd")

signal high_score
@export var scores = [3, 2, 1]
var root: Root
var title_card: CanvasLayer
var credits: CanvasLayer
var credits_card: CanvasLayer
var canvas_layer: CanvasLayer

func _enter_tree() -> void:
	root = find_child("Root")
	title_card = find_child("TitleCard")
	credits = find_child("Credits")
	canvas_layer = find_child("CanvasLayer")
	root.process_mode = Node.PROCESS_MODE_DISABLED
	root.find_child("GUI").find_child("Score").visible = false

func _on_final_score(given_score) -> void:
	for i in range(0, len(scores)):
		if (given_score > scores[i]):
			scores.insert(i, given_score)
			emit_signal("high_score")
			break
	while (len(scores) > 3):
		scores.pop_back()
	title_card.visible = true
	credits.visible = true

func _on_reload_scene() -> void:
	title_card.visible = false
	credits.visible = false
	root.queue_free()
	var new_root = root_scene.instantiate()
	new_root.connect("final_score", _on_final_score)
	new_root.connect("reload_scene", _on_reload_scene)
	connect("high_score", new_root._on_high_score)
	add_child(new_root)
	root = new_root


func _on_credits_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton or
 		event is InputEventScreenTouch):
			if (event.is_pressed()):
				var scene = credits_scene.instantiate()
				title_card.visible = false
				credits.visible = false
				add_child(scene)
				credits_card = scene
				credits_card.connect("back_pressed", exit_credits)
				canvas_layer.visible = false
				root.visible = false

func exit_credits():
	credits_card.queue_free()
	credits_card = null
	title_card.visible = true
	credits.visible = true
	root.visible = true
	canvas_layer.visible = true

func _on_touch_input(event: InputEvent) -> void:
	if (root.process_mode == Node.PROCESS_MODE_DISABLED):
		if (event.is_action_pressed("ui_accept") 
		or event is InputEventMouseButton
		or event is InputEventScreenTouch):
			if (event.is_pressed()):
				root.process_mode = Node.PROCESS_MODE_INHERIT
				root.find_child("GUI").find_child("Score").visible = true
				title_card.visible = false
				credits.visible = false
	if (root.final_score_label.visible):
		if (event.is_action_pressed("ui_accept") 
		or event is InputEventMouseButton
		or event is InputEventScreenTouch):
			if (event.is_pressed()):
				_on_reload_scene()
