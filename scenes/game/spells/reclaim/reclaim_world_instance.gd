class_name ReclaimWorldInstance extends SpellWorldInstance


func attempt_cast() -> void:
	$AnimationPlayer.play("pulse")
	await get_tree().create_timer(0.5).timeout
	for i in $ReclaimArea.get_overlapping_bodies():
		if i.has_method("reclaim"):
			i.reclaim()
	await get_tree().create_timer(0.5).timeout
	queue_free()
