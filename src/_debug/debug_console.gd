extends CanvasLayer


@onready
var element_container : VBoxContainer = $%ElementContainer


var debug_elements : Dictionary = {
	
}

# Toggles visibility of debug console
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_page_down"):
		if visible:
			visible = false
		else:
			visible = true


# Creates a debug element with the given text
func add_text_debug_element(element_id: String, element_text: String = "") -> void:
	var text_element = Label.new()
	text_element.text = element_text
	debug_elements[element_id] = text_element
	element_container.add_child(text_element)


# Updates an an element with the given text
func update_text_debug_element(element_id: String, new_element_text: String) -> bool:
	if not debug_elements.has(element_id): return false
	if not debug_elements[element_id] is Label: return false
	debug_elements[element_id].text = new_element_text
	return true


# Creates a button element with the given function
func add_button_debug_element(element_id: String, button_label: String, button_function: Callable):
	var button_element = Button.new()
	button_element.text = button_label
	button_element.pressed.connect(button_function)
	debug_elements[element_id] = button_element
	element_container.add_child(button_element)


func remove_debug_element(element_id: String):
	if not debug_elements.has(element_id): return
	debug_elements[element_id].queue_free()
	debug_elements.erase(element_id)
