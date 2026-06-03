extends Node2D

@export var edge_scene: PackedScene
@export var marker: Node2D
@export var expiration_timer: Timer

var angles = deg_to_rad(30)
var expiration_time = 6

var tilemap: TileMapLayer
var top_soundwave: Node2D
var bottom_soundwave: Node2D

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
var source_id = 0
var visible_tile_atlas_id: Vector2i = Vector2i(0, 1)

var go_for: int ## The amount of time the soundwave goes for
var touching_tiles = false
var cells_turned = []

var top_position
var bottom_position
var current_positions = []
var previous_positions

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("tilemaps")
	expiration_timer.start(expiration_time)
	_summon_soundwave(angles)
	top_soundwave = _summon_soundwave(angles)
	bottom_soundwave = _summon_soundwave(-angles)


func _summon_soundwave(angle):
	var soundwave = edge_scene.instantiate()
	soundwave.position = marker.position
	soundwave.rotation = angle
	add_child(soundwave)
	return soundwave


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tilemap and top_soundwave and bottom_soundwave:
		# Get the position of the top and bottom soundwaves
		top_position =  tilemap.local_to_map(top_soundwave.global_position)
		bottom_position = tilemap.local_to_map(bottom_soundwave.global_position)
		current_positions = [top_position, bottom_position]
		print(current_positions)
		
		# Get the cells between the two posistions and then check if the tiles exist.
		if current_positions != previous_positions:
			var cell_range = top_position.y - bottom_position.y
			
			var used_cells = []
			for tile in current_positions:
			# Checks if tile has already been turned
				if not tilemap.get_cell_atlas_coords(tile) == Vector2i(-1, -1):
					used_cells.append(tile)
			var terrain = terrain_ordering_test[current_terrain_ordering]
			tilemap.set_cells_terrain_connect(used_cells, terrain_set_test, terrain_test[terrain], true)
		previous_positions = current_positions




func _on_expiration_timer_timeout() -> void:
	queue_free()
