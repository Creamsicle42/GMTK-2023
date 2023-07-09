class_name Obelisk extends Sprite2D


const FULL = preload("res://assets/textures/props/obelisk/obelisk_full.png")
const PART_BROKEN = preload("res://assets/textures/props/obelisk/obelisk_part_broken.png")
const BROKEN = preload("res://assets/textures/props/obelisk/obelisk_broken.png")

var mana := 10


func update_view() -> void:
	if mana > 5:
		texture = FULL
	elif mana > 0:
		texture = PART_BROKEN
	else:
		texture = BROKEN


func is_player_open() -> bool:
	var bodies = $Area2D.get_overlapping_bodies()
	if bodies.size() == 0: return false
	if (bodies[0] as PlayerMain).mana_tracker.current_mana > 50: return false
	return true


func _on_spawn_timer_timeout() -> void:
	if is_player_open() and mana > 0: 
		var spark = SceneDict.MANA_SPARK.instantiate()
		get_parent().add_child(spark)
		spark.global_position = global_position
		mana -= 1
		update_view()
