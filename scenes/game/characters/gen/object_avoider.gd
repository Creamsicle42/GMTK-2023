class_name ObjectAvoider extends Area2D


@export var mover: SoftMover
@export var range : float

func _ready() -> void:
	set_meta("uid", randi())
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area2D):
	if mover == null: return
	mover.add_movement_controller(
		"%s avoider" % area.get_meta("uid", 0),
		AvoidToardsObjectController.new(area, range)
	)


func _on_area_exited(area: Area2D):
	if mover == null: return
	mover.remove_movement_controller(
		"%s avoider" % area.get_meta("uid", 0)
	)
