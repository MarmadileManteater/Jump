extends Node2D

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (get_parent().name.begins_with("EnemySpawner")):
		queue_free()
