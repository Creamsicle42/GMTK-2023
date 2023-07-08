class_name MoveToardsObjectController extends SoftMovementController

var target_object : Node2D
var target_dist : float

func _init(target: Node2D, distance: float) -> void:
	target_object = target
	target_dist = distance


func get_power_for_direction(direction: Vector2, owner: CharacterBody2D):
	var direction_to_object = (target_object.global_position - owner.global_position).normalized()
	var power = clamp(target_object.global_position.distance_to(owner.global_position) / target_dist, 0, 1)
	return direction.dot(direction_to_object) * power
