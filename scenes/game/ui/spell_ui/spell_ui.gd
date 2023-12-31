class_name SpellUI extends Control

# Acts as the UI which allows the player to select which spell to use

# SIGNALS
signal spell_button_pressed (index: int)
signal cancel_button_pressed

# CONSTANTS
const CANCEL_BUTTON_TEXTURE_SET = preload("res://assets/resources/button_texture_sets/cancel_button.tres")

# PRIVATE VARS
var _cancel_button : TextureButton

# ONREADY VARS
@onready var spell_container: HBoxContainer = %SpellContainer


# DEBUG
#func _ready() -> void:
#	render_spells([preload("res://assets/resources/spells/summon_skeletons.tres")])

# PUBLIC METHODS

# Renders the spell buttons
func render_spells(spell_array : Array[SpellType]) -> void:
	# Clear existing buttons
	_clear_buttons()
	
	# Create spell buttons
	for i in spell_array.size():
		_create_button(
				{"text" : spell_array[i].spell_name,
				"texture_set" : spell_array[i].button_set},
				_on_spell_button_pressed.bind(i)
		)
	
	# Create cancel button
	_cancel_button = _create_button(
			{"text" : "Cancel Spell",
			"texture_set": CANCEL_BUTTON_TEXTURE_SET},
			_on_cancel_select_button_pressed
	)
	set_cancel_button_enabled(false)


# Sets wether or not the cancel selection button should be enabled
func set_cancel_button_enabled(enable: bool) -> void:
	if _cancel_button == null: return
	_cancel_button.disabled = not enable


func clear_focus():
	hide()
	await get_tree().process_frame
	show()


# CALLBACK METHODS

# Called when a spell button is clicked, relays the information to the player
func _on_spell_button_pressed(button_index: int) -> void:
	spell_button_pressed.emit(button_index)
	

# Called when the "cancel selection" button is pressed
func _on_cancel_select_button_pressed() -> void:
	cancel_button_pressed.emit()
	clear_focus()


# PRIVATE METHODS

# Clears all buttons in spell container
func _clear_buttons() -> void:
	for i in spell_container.get_children():
		i.queue_free()


# Creates a button and adds it to the container.  Returns button pressed
func _create_button(button_props: Dictionary, callback: Callable) -> TextureButton:
	var button = TextureButton.new()
	button.tooltip_text = button_props.get("text", "Text Not Defined")
	button_props.get("texture_set", CANCEL_BUTTON_TEXTURE_SET).apply_to_button(button)
	button.pressed.connect(callback)
	spell_container.add_child(button)
	return button
