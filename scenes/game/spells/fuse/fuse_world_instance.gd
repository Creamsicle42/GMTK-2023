class_name FuseWorldInstance extends SpellWorldInstance


const POTENTIAL_CRAFTS:Array[FuseSpellCraft] = [
	preload("res://assets/resources/fuse_spell_crafts/large_skeleton.tres")
]


@onready var detect_area: Area2D = $DetectArea


func attempt_cast() -> void:
	$AnimationPlayer.play("pulse_out")
	await $AnimationPlayer.animation_finished
	var ingredients_in_range = get_potential_ingredients()
	var craft := get_craft(ingredients_in_range)
	
	if craft == null:
		$AnimationPlayer.play("fade")
		await $AnimationPlayer.animation_finished
		queue_free()
	else:
		for i in craft.inputs:
			(ingredients_in_range[i] as Array).pop_front().queue_free()
		var out = craft.output.instantiate()
		get_parent().add_child(out)
		out.global_position = global_position
		_caster.mana_tracker.current_mana -= 30.0
		$AnimationPlayer.play("cast")
		await $AnimationPlayer.animation_finished
		queue_free()


func get_potential_ingredients() -> Dictionary:
	var out_array : Dictionary = {}
	for i in detect_area.get_overlapping_bodies():
		if i.has_method("get_craft_type"):
			var key = i.get_craft_type()
			if out_array.has(key):
				out_array[key].append(i)
			else:
				out_array[key] = [i]
	return out_array


func get_craft(potential_ing: Dictionary) -> FuseSpellCraft:
	var ingredient_list:Array[String] = []
	for i in potential_ing:
		var ingredient_count = potential_ing[i].size()
		for k in ingredient_count:
			ingredient_list.append(i)
	for i in POTENTIAL_CRAFTS:
		if i.attempt_match(ingredient_list): return i
	
	return null
