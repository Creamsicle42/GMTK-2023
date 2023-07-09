class_name SummonSkeletonWorldInstance extends SpellWorldInstance


const SKELTON_PREFAB = preload("res://scenes/game/characters/player_minions/skeleton/skeleton.tscn")
const SPAWN_RANGE = 128.0


func attempt_cast() -> void:
	for i in 4:
		var skeleton = SKELTON_PREFAB.instantiate()
		get_parent().add_child(skeleton)
		skeleton.global_position = global_position + get_unit_circle_point() * SPAWN_RANGE
		_caster.mana_tracker.current_mana -= 5.0
		await get_tree().process_frame
	queue_free()


func get_unit_circle_point() -> Vector2:
	var out_vec := Vector2.RIGHT.rotated(randf_range(0, 2 * PI))
	return out_vec * sqrt(randf_range(0, 1))
