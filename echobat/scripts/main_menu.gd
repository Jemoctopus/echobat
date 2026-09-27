extends CanvasLayer


var player_start_position = Vector2(-6099, -763)


func _on_play_pressed() -> void:
	# Starts the game.
	get_tree().change_scene_to_file("res://scenes/level.scn")


func _on_quit_game_pressed() -> void:
	# Quits game.
	get_tree().quit()


func _on_new_game_button_down() -> void:
	# Reset variables to original positions.
	LevelManager.save_file.player_position = player_start_position
	LevelManager.save_file.insects_eaten = 0
	LevelManager.save_data()
	get_tree().change_scene_to_file("res://scenes/level.scn")
