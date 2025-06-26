extends RigidBody2D

var sprite: AnimatedSprite2D
var alive: bool = true
signal dead

func _enter_tree():
	sprite = find_child("AnimatedSprite2D")

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("ui_accept") 
	|| event is InputEventMouseButton
	|| event is InputEventScreenTouch):
		if (len(get_colliding_bodies()) != 0):
			apply_central_force(Vector2(0, -18 * 1600))
			sprite.animation = "jump_right"

func _physics_process(delta: float) -> void:
	if (len(get_colliding_bodies()) != 0 and !sprite.is_playing()):
		sprite.animation = "walk_right"
		sprite.play()
	if (position.y > 400):
		emit_signal("dead")
		alive = false
