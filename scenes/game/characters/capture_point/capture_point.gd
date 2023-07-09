class_name CapturePoint extends StaticBody2D


signal point_captured

const CAPTURED_TETURE = preload("res://assets/textures/characters/capture_point/capture_point_captured.png")

@onready var health_component: Node = $HealthComponent
@onready var capture_point_sprite: Sprite2D = $CapturePointSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D




func _on_health_component_health_depleted() -> void:
	point_captured.emit()
	capture_point_sprite.texture = CAPTURED_TETURE
	collision_shape.set_deferred("disabled", true)
