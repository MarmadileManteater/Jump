extends Node2D

const Clouds = preload("res://scripts/sky.gd")
const Trees = preload("res://scripts/trees.gd")
const Buildings = preload("res://scripts/buildings_2.gd")
const Mountains = preload("res://scripts/mountains.gd")
const Player = preload("res://scripts/player.gd")

var speed: float
var sky: Clouds
var trees: Trees
var buildings_1: Buildings
var buildings_2: Buildings
var mountains: Mountains
var player: Player
var death_sound_effect: AudioStreamPlayer2D
var reset_timer: Timer

func _enter_tree() -> void:
	sky = find_child("Sky")
	trees = find_child("Trees")
	buildings_1 = find_child("Buildings 1")
	buildings_2 = find_child("Buildings 2")
	mountains = find_child("Mountains")
	player = find_child("Player")
	death_sound_effect = find_child("DeathSoundEffect")
	reset_timer = find_child("ResetTimer")
	set_speed(1.5)
	
func set_speed(given_speed: float = 1) -> void:
	var diff = given_speed - speed
	speed = given_speed
	sky.speed = speed * 2
	trees.speed = speed * 10
	buildings_1.speed = speed * 30
	buildings_2.speed = speed * 20
	mountains.speed = speed * 40
	player.scale_speed(speed / 2)
	if (speed != 0):
		player.gravity_scale = speed / 2
		player.jump_height = 0.5 + (speed / 4)

func _on_player_dead() -> void:
	set_speed(0)
	death_sound_effect.play()
	reset_timer.start()
	
