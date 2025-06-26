extends Node2D

const Background = preload("res://scripts/background.gd")
const MultiDigitNumber = preload("res://scripts/multi_digit_number.gd")

var parallax: Background
var score: MultiDigitNumber

func _enter_tree() -> void:
	parallax = find_child("Parallax")
	score = find_child("GUI").find_child("Score")

func _on_progression_timer_timeout() -> void:
	score.set_number(score.number + 1)
	parallax.set_speed(parallax.speed + 0.1)
