extends Node2D

const root_scene = preload("res://scenes/number_2.tscn")
const credits_scene = preload("res://scenes/credits.tscn")
const Root = preload("res://scripts/number_2.gd")

signal high_score
@export var scores = [3, 2, 1]
var root: Root
var title_card: CanvasLayer
var credits: CanvasLayer
var scores_option: CanvasLayer
var scores_option_verb: Control
var scores_option_back: Control
var credits_card: CanvasLayer
var canvas_layer: CanvasLayer
var high_scores_layer: CanvasLayer
var high_score_nodes: Array
var muted: bool = false
var mute: TileMapLayer
var unmute: TileMapLayer
var volume_control: Control

func _enter_tree() -> void:
	root = find_child("Root")
	title_card = find_child("TitleCard")
	credits = find_child("Credits")
	scores_option = find_child("Scores")
	scores_option_verb = scores_option.find_child("Scores")
	scores_option_back = scores_option.find_child("Back Button")
	canvas_layer = find_child("CanvasLayer")
	high_scores_layer = find_child("High Scores")
	high_score_nodes = high_scores_layer.find_children("Score*")

	root.process_mode = Node.PROCESS_MODE_DISABLED
	root.find_child("GUI").find_child("Score").visible = false
	volume_control = find_child("Volume Toggle").find_child("Control")
	mute = volume_control.find_child("MUTE")
	unmute = volume_control.find_child("UNMUTE")
	load_game()

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
	volume_control.visible = true
	scores_option.visible = true
	save_game()

func _on_reload_scene() -> void:
	title_card.visible = false
	credits.visible = false
	scores_option.visible = false
	volume_control.visible = false
	root.queue_free()
	var new_root = root_scene.instantiate()
	new_root.connect("final_score", _on_final_score)
	new_root.connect("reload_scene", _on_reload_scene)
	connect("high_score", new_root._on_high_score)
	add_child(new_root)
	root = new_root
	set_muted(muted)

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
	volume_control.visible = true

func _on_touch_input(event: InputEvent) -> void:
	if (high_scores_layer.visible):
		#ignore input
		return
	if (root.process_mode == Node.PROCESS_MODE_DISABLED):
		if (event.is_action_pressed("ui_accept") 
		or event is InputEventMouseButton
		or event is InputEventScreenTouch):
			if (event.is_pressed()):
				root.process_mode = Node.PROCESS_MODE_INHERIT
				root.find_child("GUI").find_child("Score").visible = true
				title_card.visible = false
				credits.visible = false
				volume_control.visible = false
				scores_option.visible = false
	if (root.final_score_label.visible):
		if (event.is_action_pressed("ui_accept") 
		or event is InputEventMouseButton
		or event is InputEventScreenTouch):
			if (event.is_pressed()):
				_on_reload_scene()


func _on_mute_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton or
 		event is InputEventScreenTouch):
			if (event.is_pressed()):
				set_muted(!muted)
				save_game()
				
func set_muted(value) -> void:
	muted = value
	mute.visible = !muted
	unmute.visible = muted
	root.find_child("Parallax").set_muted(muted)

func _on_scores_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept") 
	or event is InputEventMouseButton
	or event is InputEventScreenTouch):
		if (event.is_pressed()):
			for i in range(0, len(high_score_nodes)):
				high_score_nodes[i].set_number(scores[i])
			high_scores_layer.visible = true
			title_card.visible = false
			root.gui.visible = false
			credits.visible = false
			scores_option_verb.visible = false
			scores_option_back.visible = true
				


func _on_back_scores_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept") 
	or event is InputEventMouseButton
	or event is InputEventScreenTouch):
		if (event.is_pressed()):
			high_scores_layer.visible = false
			title_card.visible = true
			root.gui.visible = true
			credits.visible = true
			scores_option_verb.visible = true
			scores_option_back.visible = false

func save_game():
	var save_file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	var save_dict = {
		"high_scores": scores,
		"muted": muted
	}
	save_file.store_string(JSON.stringify(save_dict, "  ", true))
	save_file.close()
	
func load_game():
	if not FileAccess.file_exists("user://savegame.json"):
		return 0
	var json_string = FileAccess.get_file_as_string("user://savegame.json")
	var json = JSON.new()
	
	var parse_result = json.parse(json_string)
	
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return -1
	
	var json_data = json.data
	
	scores = json_data.high_scores
	muted = json_data.muted
	set_muted(muted)
