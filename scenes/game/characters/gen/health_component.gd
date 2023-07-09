class_name HealthComponent extends Node

signal health_changed (new_health: float)
signal health_depleted
signal damage_taken (damage: float)

@export var max_health := 50.0
@export var invulnerable := false
@onready var health :float = max_health:
	set(new_health):
		damage_taken.emit(abs(health - new_health))
		if not invulnerable:
			health = clamp(new_health, 0, max_health)
			health_changed.emit(health)
			if health == 0:
				health_depleted.emit()

func change_health(change: float) -> void:
	health += change

func get_percent_health() -> float:
	return health / max_health
