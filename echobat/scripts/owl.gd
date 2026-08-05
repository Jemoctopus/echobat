extends creature_movement


func _ready() -> void:
	movement_speed = 100
	self.add_to_group("creatures")
	player_position = get_tree().get_first_node_in_group("player")
	time_check_path.start(time_between_checks)
	time_between_flaps.start(flap_time)


func _on_body_entered(body: Node2D) -> void:
	if body == player_position:
		get_tree().reload_current_scene()


func _on_path_timer_timeout() -> void:
	recalculate_goal()
