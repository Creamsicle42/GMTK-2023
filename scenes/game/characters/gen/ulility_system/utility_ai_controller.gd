class_name UtilityAIController extends Node


## Adds a boost to the current utility when updating scores to prevent switching too much
@export var current_utility_score_boost := 0.1

## The current utility
var current_utility : AIUtility


func _physics_process(delta: float) -> void:
	if current_utility == null: return
	current_utility.utility_tick(delta) 


## Updates the current utility based on the score of all utilities.
## NOT CALLED AUTOMATICALLY
func update_utility_pritority() -> void:
	var best_utility = null
	var best_utility_score = 0.0
	
	for i in get_children():
		if not i is AIUtility: continue
		var current_score = i.get_utility_score()
		
		# Give boost to current utility
		if current_utility == i:
			current_score += current_utility_score_boost
		
		# Update best if new best found
		if best_utility_score < current_score:
			best_utility = i
			best_utility_score = current_score
	
	current_utility = best_utility
