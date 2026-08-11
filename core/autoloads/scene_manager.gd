extends Node


func load_scene(scene_path: String) -> void:
	var error := get_tree().change_scene_to_file(scene_path)

	if error != OK:
		push_error("Failed to load scene: %s" % scene_path)


func restart_scene() -> void:
	get_tree().reload_current_scene()


func quit_game() -> void:
	get_tree().quit()
