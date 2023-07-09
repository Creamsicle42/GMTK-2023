class_name Main extends Node

const MAIN_MENU_SCENE = preload("res://scenes/menu/main_menu/main_menu.tscn")
const GAME_LEVELS_PATHS = [
	"res://scenes/game/levels/test_level.tscn",
	"res://scenes/menu/game_end_screen/game_end_screen.tscn"
]

var current_scene: Node
var last_loaded_level := 0
var is_changing_level := false

func _ready() -> void:
	current_scene = MAIN_MENU_SCENE.instantiate()
	add_child(current_scene)
	(current_scene as MainMenu).start_game.connect(
		load_level.bind(0)
	)


func reload_current_level() -> void:
	load_level(last_loaded_level)


func load_level(level_index: int) -> void:
	if is_changing_level: return
	if level_index >= GAME_LEVELS_PATHS.size() or level_index < 0: return
	last_loaded_level = level_index
	is_changing_level = true
	var scene_path = GAME_LEVELS_PATHS[level_index]
	ResourceLoader.load_threaded_request(scene_path)
	var loading = true
	LoadingScreen.fade_out()
	
	await get_tree().process_frame
	
	# Wait for load complete
	while loading:
		var progress := []
		var load_status := ResourceLoader.load_threaded_get_status(scene_path, progress)
		if load_status == ResourceLoader.THREAD_LOAD_LOADED:
			loading = false
		if load_status == ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Level load failed")
			return
		LoadingScreen.set_load_progress(progress[0])
		await get_tree().process_frame
	
	# Wait for fade complete
	while LoadingScreen.is_fading:
		await get_tree().process_frame
	
	# Place level
	current_scene.queue_free()
	current_scene = (ResourceLoader.load_threaded_get(scene_path) as PackedScene).instantiate()
	if current_scene.has_signal("level_complete"): current_scene.level_complete.connect(load_level.bind(level_index + 1))
	if current_scene.has_signal("player_killed"): current_scene.player_killed.connect(reload_current_level)
	add_child(current_scene)
	LoadingScreen.fade_in()
	is_changing_level = false
	
