class_name MoveToardsObjectController extends SoftMovementController

var target_object : Node2D

func get_power_for_direction(direction: Vector2, owner: CharacterBody2D):
	var direction_to_object = (target_object.global_position - owner.global_position).normalized()
	return direction.dot(direction_to_object)
