class_name AvoidToardsObjectController extends SoftMovementController

var target_object : Node2D
var max_distance : float

func _init(target: Node2D, range: float) -> void:
	target_object = target
	max_distance = range


func get_power_for_direction(direction: Vector2, owner: CharacterBody2D):
	var direction_to_object = (target_object.global_position - owner.global_position).normalized()
	var power = clamp(owner.global_position.distance_to(target_object.global_position) / max_distance, 0.0, 1.0)
	return -1 * direction.dot(direction_to_object) * ((-0.5*power) + 1)
