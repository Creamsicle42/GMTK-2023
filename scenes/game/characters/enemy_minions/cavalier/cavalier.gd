class_name Cavalier extends CharacterBody2D

@onready var health_component: Node = $HealthComponent



func get_enemy_group() -> Array[Node2D]:
	return $EnemyDetector.get_overlapping_bodies()


func do_attack(direction: Vector2) -> void:
	if not $AttackCooldown.is_stopped(): return
	$AttackCooldown.start()
	$AttackArea.rotation = direction.angle()
	for i in $AttackArea.get_overlapping_bodies():
		i.health_component.change_health(-15)


func _on_health_component_health_depleted() -> void:
	translate(Vector2(-10000, -10000))
	await get_tree().process_frame
	queue_free()
