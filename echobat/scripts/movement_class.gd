class_name creature_movement
extends CharacterBody2D

@export var navigation_agent: NavigationAgent2D
@export var time_check_path: Timer
@export var line_of_sight: RayCast2D
@export var time_between_flaps: Timer

var player_position: Node
var player_last_position: Vector2
var time_between_checks = 0.5
var player_spotted: bool = false
var nav_point_direction

# These varibles should be changed in the children classes
var gravity = 100
var lift_from_wings = 50
var flap_time = 1
var movement_speed = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_to_group("creatures")
	player_position = get_tree().get_first_node_in_group("player")
	time_check_path.start(time_between_checks)
	time_between_flaps.start(flap_time)
	


func _check_player_detection() -> bool:
	# Checks if player can be seen by the raycast.
	var collider = line_of_sight.get_collider()
	if collider and collider == get_tree().get_first_node_in_group("player"):
		return true
	return false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	player_spotted = _check_player_detection()
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


func _goal() -> void:
	# Calculates the goal that the creature wants to go to
	if navigation_agent.target_position != player_position.global_position:
		player_last_position = player_position.global_position
		navigation_agent.target_position = player_last_position


func _recalculate_goal() -> void:
	# Every time the timer timeouts we should recalulate the goal
	if player_spotted:
		_goal()
	time_check_path.start(time_between_checks)


func alert_position() -> void:
	# Lets the creature know of the player's position when they echolocate
	player_last_position = player_position.global_position
	_goal()
