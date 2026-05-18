extends Node2D

const SPEED = 500

var current_position
var tilemap: TileMapLayer
var source_id = 0
var visible_tile_atlas_id: Vector2i = Vector2i(0, 1)
var terrain_test = 0
var terrain_set_test = 0
var go_for: int ## The amount of time the soundwave goes for
var touching_tiles = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("tilemaps")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scale += Vector2(0.1, 0.1)
	move_local_x(SPEED * delta)
	if tilemap:
		current_position =  tilemap.local_to_map(global_position)
	
	if touching_tiles:
		var neighbour_cells = tilemap.get_surrounding_cells(current_position)
		neighbour_cells.append(current_position)
		tilechecker(neighbour_cells)



# Checks the selected cell for a tile, then changes it to visible. 
func tilechecker(cell: Array[Vector2i]) -> void:
	var used_cells = []
	for tile in cell:
		if not tilemap.get_cell_atlas_coords(tile) == Vector2i(-1, -1):
			used_cells.append(tile)
	tilemap.set_cells_terrain_connect(used_cells, terrain_set_test, terrain_test, true)



# The detection in which I will use echolocation
func echolocation_detection(body: Node2D) -> void:
	if tilemap:
		if body == tilemap:
			touching_tiles = true


func tilemap_exited(body: Node2D) -> void:
	if tilemap:
		if body == tilemap:
			touching_tiles = false
