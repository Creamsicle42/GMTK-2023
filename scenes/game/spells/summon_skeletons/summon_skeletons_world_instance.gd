class_name SummonSkeletonWorldInstance extends SpellWorldInstance



func attempt_cast() -> void:
	var skeleton = preload("res://scenes/game/characters/player_minions/skeleton/skeleton.tscn").instantiate()
	get_parent().add_child(skeleton)
	skeleton.global_position = global_position
	queue_free()
