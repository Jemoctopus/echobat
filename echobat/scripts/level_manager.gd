extends Node

var save_path: String = "user://save_data.save"
var player_position: Vector2

func save_data() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(player_position)


func load_data() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		player_position = file.get_var()
	else:
		player_position  = Vector2(0,0)
