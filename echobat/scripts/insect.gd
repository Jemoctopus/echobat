extends creature_movement

var how_far_away = 300.0


func _ready() -> void:
	movement_speed = 100
	self.add_to_group("creatures")
	player_position = get_tree().get_first_node_in_group("player")
	time_check_path.start(time_between_checks)
	player_spotted = _check_player_detection()


func _goal():
	player_last_position = player_position.global_position
	
	var direction_away: Vector2 = (player_last_position - global_position).normalized()
	var goal = direction_away * how_far_away
	print(goal, global_position)
	navigation_agent.target_position = goal


func _on_timer_timeout() -> void:
	_recalculate_goal()
