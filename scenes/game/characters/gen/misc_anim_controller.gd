class_name MiscAnimController extends AnimationPlayer


func set_animation(animation: String) -> void:
	if current_animation == animation: return
	play(animation)
