extends CanvasLayer


var is_fading : bool:
	get:
		return animation_player.is_playing()

@onready var progress_bar: TextureProgressBar = $ColorRect/CenterContainer/TextureProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func set_load_progress(progress: float) -> void:
	progress_bar.value = progress * 100.0


func fade_in():
	animation_player.play("fade_in")


func fade_out():
	animation_player.play("fade_out")
