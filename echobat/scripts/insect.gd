extends creature_movement

@export var marker_away: Node2D
@export var flutter_path: PathFollow2D

var how_far_away = 300.0
var speed_of_flutter = 0.02


func _ready() -> void:
	movement_speed = 100
	player_spotted = check_player_detection()
	self.add_to_group("creatures")
	player_position = get_tree().get_first_node_in_group("player")
	navigation_layer = get_tree().get_first_node_in_group("info_tilemap")
	time_check_path.start(time_between_checks)
	var random_flutter_time = randf()
	flutter_path.progress_ratio = random_flutter_time
	animation_sprite.frame_progress = random_flutter_time
	animation_sprite.play("default")


func _physics_process(delta: float) -> void:
	player_spotted = check_player_detection()
	flutter_path.progress_ratio += speed_of_flutter
	if player_position:
		line_of_sight.look_at(player_position.global_position)
		if not navigation_agent.is_target_reached():
			nav_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
			velocity = nav_point_direction * movement_speed
			if velocity.y < 0:
				velocity.y += 1
		else:
			alarm_visual.visible = false
			velocity = Vector2.ZERO
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
