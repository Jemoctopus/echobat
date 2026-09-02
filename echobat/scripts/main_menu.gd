extends CanvasLayer


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.scn")
	LevelManager.start_level()


func _on_quit_game_pressed() -> void:
	get_tree().quit()
