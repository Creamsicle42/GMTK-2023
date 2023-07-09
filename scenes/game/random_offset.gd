extends Node2D

@export var radius := 16 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position += Vector2(randf_range(-radius, radius), randf_range(-radius, radius))

