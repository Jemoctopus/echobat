class_name creature_movement
extends CharacterBody2D


@export var navigation_agent: NavigationAgent2D
@export var time_check_path: Timer
@export var line_of_sight: RayCast2D

var movement_speed = 9999
var goal: Node
var time_between_checks = 1
var player_spotted: bool = false
var player_last_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal = get_tree().get_first_node_in_group("player")
	navigation_agent.target_position = goal.global_position
	time_check_path.start(time_between_checks)
	player_spotted = _check_player_detection()


func _check_player_detection() -> bool:
	var collider = line_of_sight.get_collider()
	if collider and collider == get_tree().get_first_node_in_group("player"):
		print("SPOTTED")
		return true
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	player_spotted = _check_player_detection()
	if goal:
		line_of_sight.look_at(goal.global_position)
		if player_spotted and not navigation_agent.is_target_reached():
			var nav_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
			velocity = nav_point_direction * movement_speed * delta
			move_and_slide()


func _recalculate_goal():
	if navigation_agent.target_position != goal.global_position:
		navigation_agent.target_position = goal.global_position
	time_check_path.start(time_between_checks)
