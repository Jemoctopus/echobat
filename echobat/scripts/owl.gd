extends creature_movement


func _on_timer_timeout() -> void:
	_recalculate_goal()


func _on_body_entered(body: Node2D) -> void:
	if body == player_position:
		player_position.queue_free()
