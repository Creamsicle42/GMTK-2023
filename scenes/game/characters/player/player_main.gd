class_name PlayerMain extends CharacterBody2D

# SIGNALS
# ENUMS
# CONSTANTS
const MOVE_SPEED := 128.0
const ACCELERATION_TIME := 0.1

# EXPORTS
@export var debug_mode := false

# PUBLIC VARIABLES
# PRIVATE VARIABLES
# ONREADY VARIABLES
@onready var movement_acceleration :float = MOVE_SPEED / ACCELERATION_TIME

# BUILT IN METHODS
func _ready() -> void:
	if debug_mode:
		_setup_debug()


func _physics_process(delta: float) -> void:
	if debug_mode:
		_update_debug()
	
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

# DEBUG METHODS
func _setup_debug() -> void:
	DebugConsole.add_text_debug_element(
		"player_velocity",
		"Player Velocity: "
	)

func _update_debug() -> void:
	DebugConsole.update_text_debug_element(
		"player_velocity",
		"Player Velocity: %s" % velocity
	)
