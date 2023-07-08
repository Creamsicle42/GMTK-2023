class_name PlayerMain extends CharacterBody2D

# SIGNALS
# ENUMS
# CONSTANTS
const MOVE_SPEED := 96.0
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
@onready var mana_tracker: Node = $ManaTracker
@onready var health_component: Node = $HealthComponent



# BUILT IN METHODS
func _ready() -> void:
	if debug_mode:
		_setup_debug()
	_setup_spells()
	player_ui.mana_bar.update_value(mana_tracker.current_mana / mana_tracker.MAX_MANA)

func _process(_delta: float) -> void:
	_update_animation()


func _physics_process(delta: float) -> void:
	if debug_mode:
		_update_debug()
	
	_do_movement(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var button_event = (event as InputEventMouseButton)
		if button_event.button_index == MOUSE_BUTTON_LEFT and button_event.pressed:
			if _selected_spell == null: return
			if _selected_spell.spell_cost < mana_tracker.current_mana:
				summon_selected_spell()


# PRIVATE METHODS

# Get the input movement axis
func _get_input_move_axis() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()


# Preforms the basic movement code
func _do_movement(delta: float) -> void:
	var target_velocity :Vector2 = _get_input_move_axis() * MOVE_SPEED
	velocity = velocity.move_toward(target_velocity, movement_acceleration * delta)
	$DisplayPivot.update_direction(velocity)
	move_and_slide()
	


func set_selected_spell(spell: SpellType) -> void:
	_selected_spell = spell
	if spell == null:
		player_ui.spell_ui.set_cancel_button_enabled(false)
	else:
		player_ui.spell_ui.set_cancel_button_enabled(true)


func _update_animation() -> void:
	if not $SpellCooldownTimer.is_stopped(): return
	if _selected_spell == null:
		$DisplayPivot/AnimationPlayer.set_animation("idle")
	else:
		$DisplayPivot/AnimationPlayer.set_animation("aim")

func _setup_spells() -> void:
	player_ui.spell_ui.render_spells(spells)
	player_ui.spell_ui.spell_button_pressed.connect(_spell_button_pressed)
	player_ui.spell_ui.cancel_button_pressed.connect(_cancel_spell_button_pressed)


func _spell_button_pressed(button_index: int) -> void:
	set_selected_spell(spells[button_index])


func _cancel_spell_button_pressed() -> void:
	set_selected_spell(null)


func summon_selected_spell() -> void:
	if _selected_spell == null: return
	if not $SpellCooldownTimer.is_stopped(): return
	var spell_instance: SpellWorldInstance = _selected_spell.world_instance.instantiate()
	get_parent().add_child(spell_instance)
	spell_instance.global_position = get_global_mouse_position()
	spell_instance._caster = self
	spell_instance.attempt_cast()
	$SpellCooldownTimer.start()
	$DisplayPivot/AnimationPlayer.set_animation("cast")
	set_selected_spell(null)


func get_enemies_in_range() -> Array[Node2D]:
	return $EnemyDetector.get_overlapping_bodies()


func collect_mana_spark() -> void:
	mana_tracker.current_mana += 10


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
	DebugConsole.add_text_debug_element(
		"mana",
		"Mana: "
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
	DebugConsole.update_text_debug_element(
		"mana",
		"Mana: %s" % mana_tracker.current_mana
	)


func _on_mana_tracker_mana_value_changed(new_value) -> void:
	player_ui.mana_bar.update_value(new_value / mana_tracker.MAX_MANA)
