extends Node2D

const SPEED = 500

@export var timer_despawner: Timer

var time_till_despawn = 1.5
var current_position
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
	2 : "fadeout1_test",
	3 : "fadeout2_test",
	4 : "fadeout3_test"
}## Ordering of the terrain gradient
var current_terrain_ordering = 0

var go_for: int ## The amount of time the soundwave goes for
var touching_tiles = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("tilemaps")
	level_manager = get_tree().get_first_node_in_group("level_manager")
	timer_despawner.start(time_till_despawn)


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
	if current_terrain_ordering not in terrain_ordering_test:
		queue_free()
	else:
		# Creates new list and then checks if cells are valid, then adds valid cells to the list.
		var used_cells = []
		for tile in cell:
			if not tilemap.get_cell_atlas_coords(tile) == Vector2i(-1, -1):
				used_cells.append(tile)
		
		# Create a terrain variable, so the gradient changes
		var terrain = terrain_ordering_test[current_terrain_ordering]
		print(current_terrain_ordering)
		tilemap.set_cells_terrain_connect(used_cells, terrain_set_test, terrain_test[terrain], true)
		level_manager.cell_reset_timer(used_cells)
		current_terrain_ordering += 1
		for tile in used_cells:
			var neighbour_cells = tilemap.get_surrounding_cells(tile)
			print(neighbour_cells)
			print("tiles:", tile)
			for items in neighbour_cells:
				print("tiles", items)
				if items in cell:
					neighbour_cells.erase(items)
					print("After erase:", items, tile)
			tilechecker(neighbour_cells)



# The detection in which I will use echolocation
func echolocation_detection(body: Node2D) -> void:
	if tilemap:
		if body == tilemap:
			touching_tiles = true


func tilemap_exited(body: Node2D) -> void:
	if tilemap:
		if body == tilemap:
			touching_tiles = false


func _on_despawner_timeout() -> void:
	queue_free()
