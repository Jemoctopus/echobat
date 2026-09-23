extends CanvasLayer


func _on_play_pressed() -> void:
	LevelManager.start_level()
	get_tree().change_scene_to_file("res://scenes/level.scn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
