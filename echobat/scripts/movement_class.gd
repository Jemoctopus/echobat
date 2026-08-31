class_name creature_movement
extends CharacterBody2D

@export var navigation_agent: NavigationAgent2D
@export var time_check_path: Timer
@export var line_of_sight: RayCast2D
@export var alarm_visual: Sprite2D

var player_position: Node
var player_last_position: Vector2
var navigation_layer : TileMapLayer
var time_between_checks = 0.5
var player_spotted: bool = false
var nav_point_direction

# These varibles should be changed in the children classes
var gravity = 100
var lift_from_wings = 50
var flap_time = 1
var movement_speed = 50


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_to_group("creatures")
	player_position = get_tree().get_first_node_in_group("player")
	navigation_layer = get_tree().get_first_node_in_group("info_tilemap")
	time_check_path.start(time_between_checks)


func check_player_detection() -> bool:
	# Checks if player can be seen by the raycast.
	var collider = line_of_sight.get_collider()
	if collider and collider == player_position:
		alarm_visual.visible = true
		return true
	else:
		alarm_visual.visible = false
		return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	player_spotted = check_player_detection()
	if player_position:
		line_of_sight.look_at(player_position.global_position)
		if not navigation_agent.is_target_reached():
			nav_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
			velocity = nav_point_direction * movement_speed
			if velocity.y < 0:
				velocity.y += 1
		elif navigation_agent.is_target_reached():
			velocity = Vector2.ZERO
	move_and_slide()


func create_goal() -> void:
	# Calculates the goal that the creature wants to go to
	if player_spotted:
		if navigation_agent.target_position != player_position.global_position:
			player_last_position = player_position.global_position
			navigation_agent.target_position = player_last_position
	elif navigation_agent.navigation_finished:
		var nav_tiles = navigation_layer.get_used_cells_by_id()
		var random_number = randi_range(0, len(nav_tiles))
		var random_tile = nav_tiles[random_number]
		navigation_agent.target_position = random_tile


func recalculate_goal() -> void:
	# Every time the timer timeouts we should recalulate the goal
	create_goal()
	time_check_path.start(time_between_checks)


func alert_position() -> void:
	# Lets the creature know of the player's position when they echolocate
	player_last_position = player_position.global_position
	create_goal()
