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
var invisible_tile_atlas_id: Vector2i = Vector2i(0, 0)

var pause_between_tilemap_change = 0.1
var expiration_time = 5
var has_soundwave_expired = false ## Has soundwave has run out of time
var first_tile
var direction_facing
var direction_list = ["left", "right"]
var directionary = {
	"left" : [Vector2i(-2,-1), Vector2i(-2,1)],
	"right" : [Vector2i(2,-1), Vector2i(2,1)]
} ## Dictionary for the directions of math. Name approved by Mr Robins. 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap = get_tree().get_first_node_in_group("tilemaps")
	expiration_timer.start(expiration_time)
	
	first_tile = tilemap.local_to_map(marker.global_position)
	_soundwave()


func _soundwave() -> void:
	var top_tile = first_tile
	var bottom_tile = first_tile
	while not has_soundwave_expired:
		
		await get_tree().create_timer(pause_between_tilemap_change).timeout
	queue_free()


func _on_expiration_timer_timeout() -> void:
	has_soundwave_expired
