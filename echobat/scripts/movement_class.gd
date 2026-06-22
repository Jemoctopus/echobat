class_name creature_movement
extends CharacterBody2D


@export var navigation_agent: NavigationAgent2D
@export var time_check_path: Timer

var movement_speed = 2400
var goal: Node
var time_between_checks = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal = get_tree().get_first_node_in_group("player")
	navigation_agent.target_position = goal.global_position
	time_check_path.start(time_between_checks)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not navigation_agent.is_target_reached():
		var nav_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = nav_point_direction * movement_speed * delta
		move_and_slide()


func _recalculate_goal():
	if navigation_agent.target_position != goal.global_position:
		navigation_agent.target_position = goal.global_position
	time_check_path.start(time_between_checks)
