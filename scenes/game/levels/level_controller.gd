class_name LevelController extends Node2D

signal level_complete
signal player_killed

var capture_points_left := 0


func _ready() -> void:
	await get_tree().process_frame
	for i in get_tree().get_nodes_in_group("capture_point"):
		capture_points_left += 1
		i.point_captured.connect(
			func():
				capture_points_left -= 1
				if capture_points_left == 0:
					level_complete.emit()
					print_debug("Level Complete!")
		)
