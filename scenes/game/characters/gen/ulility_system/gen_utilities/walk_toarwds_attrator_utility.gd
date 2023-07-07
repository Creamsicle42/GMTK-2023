class_name WalkTowardsAttractorUtility extends AIUtility


@export var attractor_group := ""
@export var distance_score_curve : Curve
@export var max_distance := 256.0
@export var move_speed := 150.0
@export var stop_distance := 64.0

var current_attractor : Node2D


func _ready() -> void:
	update_closest_attractor()


## Gets the score (priority) of the utility
func get_utility_score() -> float:
	var base_utility = clamp(distance_to_closest_attractor() / max_distance, 0.0, 1.0)
	return distance_score_curve.sample(base_utility)


## Preforms the update tick for the utility
func utility_tick(_delta: float) -> void:
	var owner_pos :Vector2= owner.global_position
	var targ_pos :Vector2= current_attractor.global_position
	var owner_body = owner as CharacterBody2D
	
	if distance_to_closest_attractor() > stop_distance:
		var move_vec := (owner_pos - targ_pos).normalized()
		owner_body.velocity = move_vec * move_speed
		owner_body.move_and_slide()


func update_closest_attractor() -> void:
	current_attractor = get_closest_attractor()
	

func get_closest_attractor() -> Node2D:
	var possible_attractors := get_tree().get_nodes_in_group(attractor_group)
	if possible_attractors.size() == 0: 
		push_error("ERROR: No nodes in attractor group %s" % attractor_group)
		return owner # Just to not crash
	if possible_attractors.size() == 1: return possible_attractors[0] # Speeds up algorithim for player skeletons
	
	var closest_attractor = null
	var closest_dist := 100000000.0
	var owner_pos :Vector2= owner.global_position
	
	for i in possible_attractors:
		var targ_pos :Vector2= i.global_position
		if owner_pos.distance_squared_to(targ_pos) < closest_dist:
			closest_attractor = i
			closest_dist = owner_pos.distance_squared_to(targ_pos)
	
	return closest_attractor


func distance_to_closest_attractor() -> float:
	var owner_pos :Vector2= owner.global_position
	var targ_pos :Vector2= current_attractor.global_position
	return owner_pos.distance_to(targ_pos)
	
