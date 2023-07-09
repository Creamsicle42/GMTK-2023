extends StaticBody2D

@onready var health_component: Node = $HealthComponent

var dead = false

func _on_health_component_health_depleted() -> void:
	if dead: return
	dead = true
	var spark = SceneDict.MANA_SPARK.instantiate()
	get_parent().add_child(spark)
	spark.global_position = global_position
	$Break.pitch_scale = randf_range(0.9, 1.1)
	$Break.play()
	$AnimationPlayer.play("die")
	await $Break.finished
	queue_free()


func _on_health_component_damage_taken(damage) -> void:
	if dead: return
	$Hit.pitch_scale = randf_range(0.9, 1.1)
	$Hit.play()
