extends StaticBody2D

@onready var health_component: Node = $HealthComponent


func _on_health_component_health_depleted() -> void:
	var spark = SceneDict.MANA_SPARK.instantiate()
	get_parent().add_child(spark)
	spark.global_position = global_position
	queue_free()
