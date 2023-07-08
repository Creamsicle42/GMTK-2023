class_name HealthComponent extends Node

signal health_changed (new_health: float)
signal health_depleted

@export var max_health := 50.0

@onready var health :float = max_health:
	set(new_health):
		health = clamp(new_health, 0, max_health)
		health_changed.emit(health)
		if health == 0:
			health_depleted.emit()

func change_health(change: float) -> void:
	health += change
