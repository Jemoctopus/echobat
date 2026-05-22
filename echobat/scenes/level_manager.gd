extends Node2D

var cell_list = []
var cell_test = 0
var atlas_coord_test = Vector2i(0, 0)
var tilemap: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("tilemaps")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func cell_reset_timer(cell_list) -> void:
	await get_tree().create_timer(5.0).timeout



func reset_cell(cell_list) -> void:
	for tile in cell_list:
		tilemap.set_cell(tile, cell_test, atlas_coord_test)
