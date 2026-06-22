extends creature_movement


func _on_timer_timeout() -> void:
	_recalculate_goal()
