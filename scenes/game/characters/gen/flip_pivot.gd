class_name FlipPivot extends Node2D


var facing_right := true

func update_direction(move_vector: Vector2) -> void:
	var should_face_right := move_vector.x > 0
	var should_face_left := move_vector.x < 0
	if facing_right and should_face_left:
		scale.x = -1
		facing_right = false
	if not facing_right and should_face_right:
		scale.x = 1
		facing_right = true
