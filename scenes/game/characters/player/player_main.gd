class_name PlayerMain extends CharacterBody2D

# SIGNALS
# ENUMS
# CONSTANTS
const MOVE_SPEED := 128.0
const ACCELERATION_TIME := 0.1

# EXPORTS
# PUBLIC VARIABLES
# PRIVATE VARIABLES
# ONREADY VARIABLES
@onready var movement_acceleration :float = MOVE_SPEED / ACCELERATION_TIME

# BUILT IN METHODS

func _physics_process(delta: float) -> void:
	_do_movement(delta)


# PRIVATE METHODS

# Get the input movement axis
func _get_input_move_axis() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

# Preforms the basic movement code
func _do_movement(delta: float) -> void:
	var target_velocity :Vector2 = _get_input_move_axis() * MOVE_SPEED
	velocity = velocity.move_toward(target_velocity, movement_acceleration * delta)
	move_and_slide()
