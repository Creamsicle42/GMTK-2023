class_name SoftMover extends Node2D

@export var debug : bool
@export var movement_speed := 130.0
@export var acceleration := 150.0
@export var movement_threshold := 0.5
@export var flip_pivot : FlipPivot

var movement_controllers := {}

var debug_vectors := {}

var current_movement_direction := Vector2.ZERO

var is_moving := false

# BUILT IN METHODS

func _physics_process(delta: float) -> void:
	
	(owner as CharacterBody2D).velocity = (owner as CharacterBody2D).velocity.move_toward(
		current_movement_direction * movement_speed,
		acceleration * delta
	)
	(owner as CharacterBody2D).move_and_slide()
	
	if flip_pivot != null:
		flip_pivot.update_direction((owner as CharacterBody2D).velocity)


func _draw() -> void:
	for i in debug_vectors.keys():
		draw_line(Vector2.ZERO, i * 64 * abs(debug_vectors[i]), Color.GREEN if debug_vectors[i] > 0 else Color.RED)


# PUBLIC METHODS

func add_movement_controller(controller_id: String, controller: SoftMovementController) -> void:
	movement_controllers[controller_id] = controller


func remove_movement_controller(controller_id: String) -> void:
	movement_controllers.erase(controller_id)


func has_controller(controller_id: String) -> bool:
	return movement_controllers.has(controller_id)


func update_movement_direction() -> void:
	var best_direction := Vector2.ZERO
	var best_power := 0.0
	
	for i in range(0, 360, 22):
		var direction = Vector2.RIGHT.rotated(deg_to_rad(i))
		var power = _get_power_for_direction(direction)
		if power > best_power:
			best_power = power
			best_direction = direction
		if debug: debug_vectors[direction] = power
		
	if best_power < movement_threshold: 
		is_moving = false
		best_direction = Vector2.ZERO
	else:
		is_moving = true
	current_movement_direction = best_direction
	queue_redraw()


# PRIVATE METHODS

func _get_power_for_direction(direction: Vector2) -> float:
	var power := 0.0
	for i in movement_controllers:
		power += (movement_controllers[i] as SoftMovementController).get_power_for_direction(direction, owner)
	return power
