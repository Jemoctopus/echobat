extends Node2D

@export var edge_scene: PackedScene
@export var marker: Node2D
@export var expiration_timer: Timer

var angle_list = [deg_to_rad(215), deg_to_rad(35)]
var angle_facing = 30
var expiration_time = 2
var direction_list = ["left", "right"]
var direction_facing

var tilemap: TileMapLayer
var top_soundwave: Node2D
var bottom_soundwave: Node2D

# Terrain Variables
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
var invisible_tile_atlas_id: Vector2i = Vector2i(0, 0)

var go_for: int ## The amount of time the soundwave goes for
var touching_tiles = false
var cells_turned = []

var top_position
var bottom_position
var current_positions = []
var previous_positions
var cells_between = []
var used_cells = []
var terrain

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("tilemaps")
	expiration_timer.start(expiration_time)
	
	# Ensures that the soundwaves are named after their corresponding directions
	if direction_facing == direction_list[0]:
		top_soundwave = _summon_soundwave(angle_list[1])
		bottom_soundwave = _summon_soundwave(-angle_list[1])
	elif direction_facing == direction_list[1]:
		top_soundwave = _summon_soundwave(-angle_list[0])
		bottom_soundwave = _summon_soundwave(angle_list[0])


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
		
		# Get the cells between the two posistions and then check if the tiles exist.
		if current_positions != previous_positions:
			var cell_range = top_position.y - bottom_position.y
			for cells_between in range(cell_range):
				var cell = Vector2i(bottom_position.x, bottom_position.y + cells_between)
				if not tilemap.get_cell_atlas_coords(cell) == Vector2i(-1, -1):
					used_cells.append(cell)
			terrain = terrain_ordering_test[current_terrain_ordering]
			tilemap.set_cells_terrain_connect(used_cells, terrain_set_test, terrain_test[terrain], true)
		previous_positions = current_positions


func _on_expiration_timer_timeout() -> void:
	var fadeout1 = []
	var fadeout2 = []
	var fadeout3 = []
	var terrain_data
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
			tilemap.set_cell(cells, source_id, invisible_tile_atlas_id)
			queue_free()
	tilemap.set_cells_terrain_connect(fadeout1, terrain_set_test, terrain_test["fadeout1"], true)
	tilemap.set_cells_terrain_connect(fadeout2, terrain_set_test, terrain_test["fadeout2"], true)
	tilemap.set_cells_terrain_connect(fadeout3, terrain_set_test, terrain_test["fadeout3"], true)
