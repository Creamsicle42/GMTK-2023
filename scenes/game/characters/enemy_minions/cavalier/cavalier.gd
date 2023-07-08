class_name Cavalier extends CharacterBody2D


func get_enemy_group() -> Array[Node2D]:
	return $EnemyDetector.get_overlapping_bodies()


func do_attack(direction: Vector2) -> void:
	if not $AttackCooldown.is_stopped(): return
	$AttackCooldown.start()
	$AttackArea.rotation = direction.angle()
	for i in $AttackArea.get_overlapping_bodies():
		i.health_component.change_health(-15)


func _on_health_component_health_depleted() -> void:
	queue_free()
