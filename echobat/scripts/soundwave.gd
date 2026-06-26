extends Node2D


@export var marker: Node2D ## The Marker in which we gain our position
@export var expiration_timer: Timer ## Times how long the scene should last

var tilemap: TileMapLayer
var terrain_test = {
	"bright" : 0,
	"fadeout1" : 1,
	"fadeout2" : 2,
	"fadeout3" : 3
} ## Terrain gradient keys
var terrain_ordering_test  = {
	0 : "bright",
	1 : "fadeout1",
	2 : "fadeout2",
	3 : "fadeout3"
} ## Ordering of the terrain gradient
var current_terrain_ordering = 0
var terrain_set_test = 0
var source_id = 0
var white_tile_atlas_id: Vector2i = Vector2i(0, 4)
var black_tile_atlas_id: Vector2i = Vector2i(0, 0)
var pause_between_tilemap_change = 0.02
var expiration_time = 1.0
var has_soundwave_expired = false ## Has soundwave has run out of time
var set_point ## The tile coordinates which the soundwave starts at. 
var used_cells = []
var direction_facing
var direction_list = ["left", "right"]
var directionary = {
	"left" : [Vector2i(-2,-1), Vector2i(-2,1)],
	"right" : [Vector2i(2,-1), Vector2i(2,1)]
} ## Dictionary for the directions of math. Name approved by Mr Robins. 
var direction_additions = {
	"left" : -1,
	"right" : 1
} ## Directions for filling in the blanks


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("tilemaps")
	expiration_timer.start(expiration_time)
	if tilemap:
		set_point = tilemap.local_to_map(marker.global_position)
		_soundwave()


func _soundwave() -> void:
	var top_tile = set_point
	var bottom_tile = set_point
	var direction_going = directionary[direction_facing]
	var how_apart
	var cell
	var all_used_cells = tilemap.get_used_cells()
	while not has_soundwave_expired:
		top_tile += direction_going[0]
		bottom_tile += direction_going[1]
		how_apart = bottom_tile.y - top_tile.y
		for cells_between in range(how_apart):
			# The first column of cells
			cell = Vector2i(top_tile.x, top_tile.y + cells_between)
			if not tilemap.get_cell_atlas_coords(cell) == Vector2i(-1, -1):
				used_cells.append(cell)
			# The second column of cells so there isn't a gap. 
			cell = Vector2i(top_tile.x + direction_additions[direction_facing], top_tile.y + cells_between)
			if not tilemap.get_cell_atlas_coords(cell) == Vector2i(-1, -1):
				used_cells.append(cell)
		tilemap.set_cells_terrain_connect(used_cells, terrain_set_test, 0, true)
		await get_tree().create_timer(pause_between_tilemap_change).timeout
	queue_free()


func _on_expiration_timer_timeout() -> void:
	has_soundwave_expired = true


func _turn_tilemap_back() -> void:
	var fadeout1 = []
	var fadeout2 = []
	var fadeout3 = []
	var terrain_data
	if tilemap:
		for cells in used_cells:
			terrain_data = tilemap.get_cell_tile_data(cells)
			terrain_data = terrain_data.terrain
			if terrain_data == 0:
				fadeout1.append(cells)
			elif terrain_data == 1:
				fadeout2.append(cells)
			elif terrain_data == 2:
				fadeout3.append(cells)
			elif terrain_data == 3:
				tilemap.set_cell(cells, source_id, black_tile_atlas_id)
				queue_free()
		tilemap.set_cells_terrain_connect(fadeout1, terrain_set_test, terrain_test["fadeout1"], true)
		tilemap.set_cells_terrain_connect(fadeout2, terrain_set_test, terrain_test["fadeout2"], true)
		tilemap.set_cells_terrain_connect(fadeout3, terrain_set_test, terrain_test["fadeout3"], true)
