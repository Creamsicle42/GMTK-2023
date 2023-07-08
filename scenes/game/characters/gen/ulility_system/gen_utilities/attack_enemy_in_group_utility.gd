class_name AttackEnemyInGroupUtility extends AIUtility


@export var attack_closest := true
@export var distance_score_curve : Curve
@export var max_distance := 256.0
@export var stop_distance := 64.0
@export var attack_range := 64.0
@export var mover : SoftMover

var current_attractor : Node2D
var move_controller : SoftMovementController = MoveToardsObjectController.new(owner, max_distance)

func _ready() -> void:
	update_closest_attractor()


## Gets the score (priority) of the utility
func get_utility_score() -> float:
	if owner.get_enemy_group().size() == 0: return 0.0
	var base_utility = clamp(distance_to_closest_attractor() / max_distance, 0.0, 1.0)
	return distance_score_curve.sample(base_utility)


## Preforms the update tick for the utility
func utility_tick(_delta: float) -> void:
	var owner_pos :Vector2= owner.global_position
	if current_attractor == null:
		update_closest_attractor()
		return
	var targ_pos :Vector2= current_attractor.global_position
	var owner_body = owner as CharacterBody2D
	
	if distance_to_closest_attractor() > stop_distance:
		if not mover.has_controller("move_toards_target"):
			mover.add_movement_controller("move_toards_target", move_controller)
	else:
		
		if  mover.has_controller("move_toards_target"):
			mover.remove_movement_controller("move_toards_target")
	if distance_to_closest_attractor() < attack_range:
		if owner.has_method("do_attack"):
			owner.do_attack((targ_pos - owner_pos).normalized())


func update_closest_attractor() -> void:
	current_attractor = get_closest_attractor()
	move_controller = MoveToardsObjectController.new(current_attractor, max_distance)
	

func get_closest_attractor() -> Node2D:
	var possible_attractors :Array[Node2D] = owner.get_enemy_group()
	if possible_attractors.size() == 0: 
		return owner # Just to not crash
	if possible_attractors.size() == 1: return possible_attractors[0] # Speeds up algorithim for player skeletons
	if not attack_closest: return possible_attractors[0] # Speeds up enemy attacking
	
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
	if current_attractor == null: 
		update_closest_attractor()
		return 100000.0
	var targ_pos :Vector2= current_attractor.global_position
	
	return owner_pos.distance_to(targ_pos)


func enter_utility():
	update_closest_attractor()
	mover.add_movement_controller("move_toards_target", move_controller)


func exit_utility():
	mover.remove_movement_controller("move_toards_target")
