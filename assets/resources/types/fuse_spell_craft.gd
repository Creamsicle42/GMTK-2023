class_name FuseSpellCraft extends Resource

@export var output : PackedScene
@export var inputs : Array[String]

func attempt_match(potential_inputs: Array[String]) -> bool:
	var needed_inputs = inputs.duplicate()
	for i in potential_inputs:
		if needed_inputs.has(i):
			needed_inputs.erase(i)
	return needed_inputs.size() == 0
