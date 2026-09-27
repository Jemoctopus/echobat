extends creature_movement


func _ready() -> void:
	# Set variables.
	movement_speed = 200
	self.add_to_group("creatures")
	player_position = get_tree().get_first_node_in_group("player")


func _on_body_entered(body: Node2D) -> void:
	# Sees if player is first within raycast sight.
	if body == player_position:
		get_tree().reload_current_scene()


func _on_path_timer_timeout() -> void:
	# Recalculate goal timer.
	print("Woo")
	recalculate_goal()
