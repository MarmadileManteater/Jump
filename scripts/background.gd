extends Node2D

const Clouds = preload("res://scripts/sky.gd")
const Trees = preload("res://scripts/trees.gd")
const Buildings = preload("res://scripts/buildings_2.gd")
const Mountains = preload("res://scripts/mountains.gd")

var sky: Clouds
var trees: Trees
var buildings_1: Buildings
var buildings_2: Buildings
var mountains: Mountains

func _enter_tree() -> void:
	sky = find_child("Sky")
	trees = find_child("Trees")
	buildings_1 = find_child("Buildings 1")
	buildings_2 = find_child("Buildings 2")
	mountains = find_child("Mountains")
	set_speed(2)
	
func set_speed(speed: float = 1) -> void:
	sky.speed = speed * 2
	trees.speed = speed * 10
	buildings_1.speed = speed * 30
	buildings_2.speed = speed * 20
	mountains.speed = speed * 40 
pass # Replace with function body.

func _on_player_dead() -> void:
	set_speed(0)
