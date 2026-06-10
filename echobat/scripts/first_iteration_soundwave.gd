extends Node2D

const SPEED = 1000

var time_till_despawn = 1.5
var current_position: Vector2i = Vector2i.ZERO
var tilemap: TileMapLayer
var level_manager: Node2D
var source_id = 0
var visible_tile_atlas_id: Vector2i = Vector2i(0, 1)

# Terrain Variables
var terrain_test = {
	"bright_test" : 0,
	"fadeout1_test" : 1,
	"fadeout2_test" : 2,
	"fadeout3_test" : 3
	}
var terrain_set_test = 0
var terrain_ordering_test  = {
	0 : "bright_test",
	1 : "bright_test",
	2 : "bright_test",
	3 : "bright_test",
	4 : "bright_test",
	5 : "fadeout1_test",
	6 : "fadeout2_test",
	7 : "fadeout3_test"
}## Ordering of the terrain gradient
var current_terrain_ordering = 0

var go_for: int ## The amount of time the soundwave goes for
var touching_tiles = false
var cells_turned = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("tilemaps")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale += Vector2(0.1, 0.1)
	move_local_x(SPEED * delta)
	if tilemap:
		current_position =  tilemap.local_to_map(global_position)


# Checks the selected cell for a tile, then changes it to visible. 
func tilechecker(cell: Array[Vector2i]) -> void:
	if current_terrain_ordering not in terrain_ordering_test:
		queue_free()
	else:
		# Creates new list and then checks if cells are valid, then adds valid cells to the list.
		var used_cells = []
		for tile in cell:
			# Checks if tile has already been turned
			if not tilemap.get_cell_atlas_coords(tile) == Vector2i(-1, -1):
				used_cells.append(tile)
		
		# Create a terrain variable, so the gradient changes
		var terrain = terrain_ordering_test[current_terrain_ordering]
		tilemap.set_cells_terrain_connect(used_cells, terrain_set_test, terrain_test[terrain], true)
		#level_manager.recieve_cell_data(cells_turned)
		current_terrain_ordering += 1
		for tile in used_cells:
			var neighbour_cells = tilemap.get_surrounding_cells(tile)
			for items in neighbour_cells:
				if items in cell:
					neighbour_cells.erase(items)
			tilechecker(neighbour_cells)


# The detection in which I will use echolocation
func echolocation_detection(body: Node2D) -> void: 
	if body == tilemap:
		var neighbour_cells = tilemap.get_surrounding_cells(current_position)
		neighbour_cells.append(current_position)
		tilechecker(neighbour_cells)
