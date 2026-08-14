extends creature_movement

var how_far_away = 300.0
@export var marker_away: Node2D
@export var flutter_path: PathFollow2D


func _ready() -> void:
	movement_speed = 60
	flap_time = 0.5
	lift_from_wings = 55
	gravity = 100
	player_spotted = check_player_detection()
	self.add_to_group("creatures")
	player_position = get_tree().get_first_node_in_group("player")
	navigation_layer = get_tree().get_first_node_in_group("info_tilemaps")
	time_check_path.start(time_between_checks)
	var random_flutter_time = randf_range(0.0, 1.0)
	flutter_path.progress_ratio = random_flutter_time


func _physics_process(delta: float) -> void:
	player_spotted = check_player_detection()
	flutter_path.progress_ratio += 0.01
	if player_position:
		line_of_sight.look_at(player_position.global_position)
		if not navigation_agent.is_target_reached():
			nav_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
			velocity = nav_point_direction * movement_speed
			if velocity.y < 0:
				velocity.y += 1
		elif navigation_agent.is_target_reached():
			velocity = Vector2(0,0)
	move_and_slide()


func create_goal():
	if player_spotted:
		player_last_position = player_position.global_position
		var goal = marker_away.global_position
		navigation_agent.target_position = goal
	#elif navigation_agent.navigation_finished:
	#	var nav_tiles = navigation_layer.get_used_cells_by_id()
	#	var random_number = randi_range(0, len(nav_tiles))
	#	var random_tile = nav_tiles[random_number]
	#	navigation_agent.target_position = random_tile


func _on_path_timer_timeout() -> void:
	recalculate_goal()


func _body_enter_area(body: Node2D) -> void:
	if body == player_position:
		queue_free()
