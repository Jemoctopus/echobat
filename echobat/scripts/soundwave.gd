extends Node2D

const SPEED = 500

var current_position
var tilemap: TileMapLayer
var source_id = 0
var visible_tile_atlas_id: Vector2i = Vector2i(0, 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("tilemaps")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_local_x(SPEED * delta)
	if tilemap:
		current_position =  tilemap.local_to_map(global_position)


# The detection in which I will use echolocation
func echolocation_detection(body: Node2D) -> void:
	if tilemap:
		if body == tilemap:
			var has_tile = tilemap.get_cell_atlas_coords(current_position)
			if has_tile != Vector2i(-1, -1):
				tilemap.set_cell(current_position, source_id, visible_tile_atlas_id)
				queue_free()
