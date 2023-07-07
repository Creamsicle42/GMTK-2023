class_name SoftMover extends Node

@export var movement_speed := 150.0
@export var movement_threshold := 0.5

var movement_controllers := {}

# BUILT IN METHODS

func _physics_process(delta: float) -> void:
	var best_direction := Vector2.ZERO
	var best_power := 0.0
	for i in range(0, 2 * PI, deg_to_rad(45/2)):
		var direction = Vector2.RIGHT.rotated(i)
		var power = _get_power_for_direction(direction)
		if power > best_power:
			best_power = power
			best_direction = direction
	if best_power < movement_threshold: best_direction = Vector2.ZERO
	(owner as CharacterBody2D).velocity = best_direction * movement_speed
	(owner as CharacterBody2D).move_and_slide()


# PUBLIC METHODS

func add_movement_controller(controller_id: String, controller: SoftMovementController):
	movement_controllers[controller_id] = controller


func remove_movement_controller(controller_id: String):
	movement_controllers.erase(controller_id)

# PRIVATE METHODS

func _get_power_for_direction(direction: Vector2) -> float:
	var power := 0.0
	for i in movement_controllers:
		power += (i as SoftMovementController).get_power_for_direction(direction, owner)
	return power
