extends RigidBody2D

var death_timer: Timer
var sprite: AnimatedSprite2D
var jump_sound_effect: AudioStreamPlayer2D
var food_sound_effect: AudioStreamPlayer2D
var alive: bool = true
var is_jumping: bool = false
var speed_scale: float = 1
var jump_height: float
var muted: bool = false
signal dead
signal score

func scale_speed(speed: float):
	speed_scale = speed
	if (sprite != null):
		sprite.speed_scale = speed_scale

func _enter_tree():
	sprite = find_child("AnimatedSprite2D")
	death_timer = find_child("DeathTimer")
	jump_sound_effect = find_child("JumpSoundEffect")
	food_sound_effect = find_child("FoodSoundEffect")
	scale_speed(speed_scale)

func _input(event: InputEvent) -> void:
	if (!is_jumping and alive):
		if (event.is_action_pressed("ui_accept") 
		or event is InputEventMouseButton
		or event is InputEventScreenTouch):
			if (len(get_colliding_bodies()) != 0):
				is_jumping = true
				apply_central_force(Vector2(0, (-18 * 2600) * jump_height))
				sprite.animation = "jump_right"
				if (!muted):
					jump_sound_effect.play()

func _physics_process(delta: float) -> void:
	var food_collided_with = get_colliding_bodies().filter(func (body: StaticBody2D): return body.name.begins_with("Food"))
	var will_return = len(food_collided_with) == 1
	while (len(food_collided_with) != 0):
		food_collided_with.pop_front().queue_free()
		emit_signal("score", 1)
		if (!muted):
			food_sound_effect.play()
	if (will_return):
		return
	var enemies_collided_with = get_colliding_bodies().filter(func (body: StaticBody2D): return body.name.begins_with("Enemy"))
	if (len(enemies_collided_with) != 0 and alive):
		alive = false
		emit_signal("dead")
		death_timer.start()
	if (len(get_colliding_bodies()) != 0 and !sprite.is_playing()):
		sprite.animation = "walk_right"
		sprite.play()
		is_jumping = false
	if (len(get_colliding_bodies()) == 0):
		sprite.animation = "jump_right"
		is_jumping = true
	if (position.y > 400 and alive):
		emit_signal("dead")
		alive = false
		death_timer.start()


func _on_death_timer_timeout() -> void:
	collision_layer = 4
	collision_mask = 4
	z_index = 10
