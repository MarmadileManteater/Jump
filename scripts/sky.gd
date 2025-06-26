extends Sprite2D

@export var speed = 2
var clouds: Array = []

func _enter_tree() -> void:
	var letters = ["A", "B", "C", "D", "E"]
	for letter in letters:
		clouds.append(find_child("Cloud%s" % letter))

func _physics_process(delta: float) -> void:
	for cloud in clouds:
		cloud.position[0] -= delta * speed
		if (cloud.position[0] <= -78.733):
			cloud.position[0] = 212.666
