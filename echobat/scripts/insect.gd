extends creature_movement

var how_far_away = 300.0
@export var marker_away: Node2D


func _ready() -> void:
	movement_speed = 60
	flap_time = 0.5
	lift_from_wings = 55
	gravity = 100
	time_between_flaps.start(flap_time)
	self.add_to_group("creatures")
	player_position = get_tree().get_first_node_in_group("player")
	time_check_path.start(time_between_checks)
	player_spotted = _check_player_detection()


func _goal():
	player_last_position = player_position.global_position
	var goal = marker_away.global_position
	navigation_agent.target_position = goal


func _on_path_timer_timeout() -> void:
	_recalculate_goal()


func _body_enter_area(body: Node2D) -> void:
	if body == player_position:
		queue_free()


func _on_flap_timer_timeout() -> void:
	flap_wings()
	time_between_flaps.start(flap_time)
