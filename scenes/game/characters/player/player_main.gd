class_name PlayerMain extends CharacterBody2D

# SIGNALS
# ENUMS
# CONSTANTS
const MOVE_SPEED := 128.0
const ACCELERATION_TIME := 0.1


# EXPORTS
@export var debug_mode := false
@export var spells : Array[SpellType]


# PUBLIC VARIABLES


# PRIVATE VARIABLES
var _selected_spell : SpellType


# ONREADY VARIABLES
@onready var player_ui: PlayerUI = $PlayerUI
@onready var movement_acceleration :float = MOVE_SPEED / ACCELERATION_TIME


# BUILT IN METHODS
func _ready() -> void:
	if debug_mode:
		_setup_debug()
	_setup_spells()


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


func set_selected_spell(spell: SpellType) -> void:
	_selected_spell = spell
	if spell == null:
		player_ui.spell_ui.set_cancel_button_enabled(false)
	else:
		player_ui.spell_ui.set_cancel_button_enabled(true)


func _setup_spells() -> void:
	player_ui.spell_ui.render_spells(spells)
	player_ui.spell_ui.spell_button_pressed.connect(_spell_button_pressed)
	player_ui.spell_ui.cancel_button_pressed.connect(_cancel_spell_button_pressed)


func _spell_button_pressed(button_index: int) -> void:
	set_selected_spell(spells[button_index])


func _cancel_spell_button_pressed() -> void:
	set_selected_spell(null)


# DEBUG METHODS
func _setup_debug() -> void:
	DebugConsole.add_text_debug_element(
		"player_velocity",
		"Player Velocity: "
	)
	DebugConsole.add_text_debug_element(
		"selected_spell",
		"Selected Spell: "
	)


func _update_debug() -> void:
	DebugConsole.update_text_debug_element(
		"player_velocity",
		"Player Velocity: %s" % velocity
	)
	DebugConsole.update_text_debug_element(
		"selected_spell",
		"Selected Spell: %s" % (_selected_spell.spell_name if _selected_spell != null else "None") 
	)
