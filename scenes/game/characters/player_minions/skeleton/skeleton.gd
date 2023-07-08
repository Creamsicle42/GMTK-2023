class_name Skeleton extends CharacterBody2D


@onready var player : PlayerMain = get_tree().get_first_node_in_group("player")
@onready var health_component: Node = $HealthComponent


func get_enemy_group() -> Array[Node2D]:
	if player == null: return []
	return player.get_enemies_in_range()


func _on_health_component_health_depleted() -> void:
	queue_free()
