extends Node2D


@export var marker: Node2D ## The Marker in which we gain our position
@export var expiration_timer: Timer ## Times how long the scene should last

var tilemap_dark: TileMapLayer
var tilemap_visible: TileMapLayer

var source_id = 0
var atlas_id_dict = {
	"erase" : Vector2i(-1,-1),
	"fadeout1" : Vector2i(0, 3),
	"fadeout2" : Vector2i(0, 2),
	"fadeout3" : Vector2i(0, 1),
	"black" : Vector2i(0, 0)
}
var atlas_id_order = {
	0 : "erase",
	1 : "erase",
	2 : "fadeout1",
	3 : "fadeout2",
	4 : "fadeout3",
	5 : "black"
	
}
var current_atlas_order_number = 1
var current_atlas_order_name = atlas_id_order[current_atlas_order_number] ## The current tile altas id selected
var atlas_id : Vector2i
var erase_tile_atlas_id: Vector2i = Vector2i(-1,-1)
var length_of_gradient = len(atlas_id_order) - 1

var pause_between_tilemap_change = 0.01
var pause_between_tilemap_hides = 3
var expiration_time = 1.5
var has_soundwave_expired = false ## Has soundwave has run out of time
var set_point ## The tile coordinates which the soundwave starts at. 
var used_cells = []

var direction_facing
var direction_left_right = ["left", "right"]
var direction_up_down = ["up", "down"]
var directionary = {
	"left" : [Vector2i(-1,-1), Vector2i(-1,1)],
	"right" : [Vector2i(1,-1), Vector2i(1,1)],
	"up" : [Vector2i(-1, -1), Vector2i(1, -1)],
	"down" : [Vector2i(-1, 1), Vector2i(1, 1)]
} ## Dictionary for the directions so I can store the math. Name approved by Mr Robins. 


func _ready() -> void:
	# Get the tilemap layer and set the setpoint 
	tilemap_dark = get_tree().get_first_node_in_group("tilemaps")
	expiration_timer.start(expiration_time)
	if tilemap_dark:
		set_point = tilemap_dark.local_to_map(marker.global_position)
		_soundwave()


# Called in the start to trigger 
func _soundwave() -> void:
	var top_tile = set_point ## The top of the soundwave.
	var bottom_tile = set_point ## The bottom of the soundwave.
	var direction_going = directionary[direction_facing] ## The direction the soundwave is going.
	var how_apart ## How far apart the soundwaves are.
	var cell ## The current cell in which I will use to change the tilemap.
	atlas_id = atlas_id_dict[current_atlas_order_name]
	while not has_soundwave_expired:
		# Loops keeps the soundwave going until the timer goes out.
		top_tile += direction_going[0]
		bottom_tile += direction_going[1]
		if direction_facing == direction_left_right[0] or direction_facing == direction_left_right[1]:
			how_apart = abs(bottom_tile.y - (top_tile.y - 1))
			for cells_between in range(how_apart):
			# The first column of cells
				cell = Vector2i(top_tile.x, top_tile.y + cells_between)
				if not tilemap_dark.get_cell_atlas_coords(cell) == Vector2i(-1, -1):
					used_cells.append(cell)
					tilemap_dark.set_cell(cell, source_id, atlas_id)
		elif direction_facing == direction_up_down[0] or direction_facing == direction_up_down[1]:
			how_apart = abs(top_tile.x - (bottom_tile.x + 1))
			for cells_between in range(how_apart):
				# The first column of cells
				cell = Vector2i(top_tile.x + cells_between, top_tile.y)
				if not tilemap_dark.get_cell_atlas_coords(cell) == Vector2i(-1, -1):
					used_cells.append(cell)
					tilemap_dark.set_cell(cell, source_id, atlas_id)
		await get_tree().create_timer(pause_between_tilemap_change).timeout
	expiration_timer.start(expiration_time)


func _on_expiration_timer_timeout() -> void:
	has_soundwave_expired = true
	_turn_tilemap_back()


func _turn_tilemap_back() -> void:
	for gradient in range(length_of_gradient):
		print(gradient)
		await get_tree().create_timer(pause_between_tilemap_hides).timeout
		if tilemap_dark:
			current_atlas_order_name = atlas_id_order[gradient]
			atlas_id = atlas_id_dict[current_atlas_order_name]
			for cells in used_cells:
				tilemap_dark.set_cell(cells, source_id, atlas_id)
	queue_free()
