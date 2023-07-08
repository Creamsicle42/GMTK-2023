extends Control

var tweener : Tween


func update_value(new_value: float) -> void:
	if tweener != null: tweener.kill()
	tweener = get_tree().create_tween()
	tweener.tween_property($TextureProgressBar, "value", new_value * 100, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tweener.play()
