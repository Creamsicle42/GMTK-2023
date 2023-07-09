class_name Cutscene extends Node2D

signal level_complete

func complete() -> void:
	level_complete.emit()
