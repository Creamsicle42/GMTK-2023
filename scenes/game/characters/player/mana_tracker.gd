class_name ManaTracker extends Node

## Tracks the players mana count

signal mana_value_changed (new_value: float)

const MAX_MANA = 100.0
const MANA_REGEN_LIMIT := 50.0
const MANA_REGEN_RATE := 50.0

var current_mana := 0.0 :
	set(new_value):
		current_mana = clamp(new_value, 0, MAX_MANA)
		mana_value_changed.emit(current_mana)


func _physics_process(delta: float) -> void:
	if current_mana < MANA_REGEN_LIMIT:
		current_mana = clamp(current_mana + MANA_REGEN_RATE * delta, 0.0, MANA_REGEN_LIMIT)


