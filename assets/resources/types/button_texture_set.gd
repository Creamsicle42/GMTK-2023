class_name ButtonTextureSet extends Resource

@export var base : Texture
@export var pressed : Texture
@export var selected : Texture
@export var disabled : Texture


func apply_to_button(button: TextureButton) -> void:
	button.texture_normal = base
	button.texture_pressed = pressed
	button.texture_focused = selected
	button.texture_disabled = disabled
