extends Node

@export var info_layer: TileMapLayer
@export var hidden_layer: TileMapLayer
@export var base_layer: TileMapLayer


var save_path: String = "user://save_data.save"
var player_position: Vector2
var black_tile_atlas_id: Vector2i = Vector2i(0, 0)


func _ready() -> void:
	# Creates the base layer from the hidden layer, so I don't have to create an identical layer. 
	if hidden_layer and base_layer:
		var all_cells = hidden_layer.get_used_cells()
		for cell in all_cells:
			base_layer.set_cell(cell, 0, black_tile_atlas_id)


func save_data() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(player_position)


func load_data() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		player_position = file.get_var()
	else:
		player_position  = Vector2(0,0)


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.scn")
