class_name LineTrail extends Line2D

@export var trail_length := 16
@export var point_minimum_distance := 16.0

func _ready() -> void:
	top_level = true
	global_position = Vector2.ZERO
	add_point(get_parent().global_position)


func _physics_process(delta: float) -> void:
	global_position = Vector2.ZERO
	if(get_point_position(0).distance_to(get_parent().global_position) > point_minimum_distance):
		add_point(get_parent().global_position, 0)
	if(get_point_count() > trail_length): remove_end_point()


func remove_end_point() -> void:
	if get_point_count() == 1: return
	remove_point(get_point_count() - 1)
