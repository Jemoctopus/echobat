extends Node

const SAVE_PATH: String = "user://save_data1.json"


var info_layer: TileMapLayer
var hidden_layer: TileMapLayer
var dark_layer: TileMapLayer
var game_running = true

# Save variables
var save_file: Dictionary = {
	"player_position" : Vector2(-6099, -763),
	"insects_eaten" : 0
}
var save_file_items = ["player_position", "insects_eaten"]
var player_position: Vector2
var insects_eaten: int

# Variables to do with the cells
var pause_between_tilemap_hides = 2 ## The delay between the different soundwaves.
var used_cells = []
var source_id = 0
var atlas_id_dict = {
	"erase" : Vector2i(-1,-1),
	"fadeout1" : Vector2i(0, 0),
	"fadeout2" : Vector2i(1, 0),
	"fadeout3" : Vector2i(2, 0),
	"fadeout4" : Vector2i(3, 0),
	"black" : Vector2i(4, 0),
}
var atlas_id_order = ["erase", "fadeout1", "fadeout2", "fadeout3", "fadeout4", "black"]
var current_atlas_id = atlas_id_dict[atlas_id_order[-1]]
var current_cell: Vector2i
var set_atlas_id 
var all_dark = false
var takeaway = 0


func start_level() -> void:
	hidden_layer = get_tree().get_first_node_in_group("hidden_tilemap")
	dark_layer = get_tree().get_first_node_in_group("dark_tilemap")
	info_layer = get_tree().get_first_node_in_group("info_tilemap")
	# Creates the base layer from the hidden layer, so I don't have to create an identical layer. 
	if hidden_layer and dark_layer and info_layer:
		var all_cells = hidden_layer.get_used_cells()
		for cell in all_cells:
			info_layer.erase_cell(cell)
			dark_layer.set_cell(cell, source_id, current_atlas_id)
	tilemap_hide()


func save_data() -> void:
	# Saves the data to be stored
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(save_file.duplicate())
	file.close()


func load_data() -> void:
	# Loads the stored data
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		file.close()
		var save_data = data.duplicate()
		save_file[save_file_items[0]] = save_data[save_file_items[0]]
		save_file[save_file_items[1]] = save_data[save_file_items[1]]
	else:
		save_file[save_file_items[0]]


func tilemap_hide() -> void:
	# Hides the tilemap 
	while game_running:
		takeaway = 0
		for cells in range(len(used_cells)):
			cells -= takeaway
			if typeof(used_cells[cells]) == typeof(null):
				takeaway += 1
				used_cells.remove_at(cells)
		# Waits for a bit
		await get_tree().create_timer(pause_between_tilemap_hides).timeout
		# If there is cells in the used_cells list, then change cell to next gradient
		if used_cells:
			# For every cell, check atlas id 
			for cell in range(len(used_cells)):
				# Checks if cell is real
				if used_cells[cell]:
					current_cell = Vector2i(used_cells[cell])
				else:
					break
				# Gets atlas coords and then changes it to the next gradient
				current_atlas_id = dark_layer.get_cell_atlas_coords(current_cell)
				if current_atlas_id == atlas_id_dict[atlas_id_order[0]]:
					dark_layer.set_cell(current_cell, source_id, atlas_id_dict[atlas_id_order[1]])
				elif current_atlas_id != atlas_id_dict[atlas_id_order[-1]]:
					for atlas_ids in range(len(atlas_id_order) - 1):
						if atlas_id_dict[atlas_id_order[atlas_ids]] == current_atlas_id:
							atlas_ids += 1
							dark_layer.set_cell(current_cell, source_id, atlas_id_dict[atlas_id_order[atlas_ids]])
				else:
					used_cells[cell] = null
