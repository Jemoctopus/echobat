extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -350.0

@export var soundwave_scene: PackedScene ## The soundwave that the bat shoots
@export var right_soundwave_spawn: Node2D ## The right marker in which we spawn the soundwaves from 
@export var left_soundwave_spawn: Node2D ## The left marker in which we spawn the soundwaves from 
@export var up_down_soundwave_spawn: Node2D ## The up marker in which we spawn the soundwaves from 
@export var bat_body: Node2D ## The bats body in which we play visuals and locate the directions
@export var soundwave_timer: Timer ## The timer which times time inbetween soundwave
@export var level_tilemap: TileMapLayer ## The tilemap which the player will change
@export var info_tilemap: TileMapLayer ## The tilemap which gives information to the player to decide actions


var direction_bat_facing = ["left", "right", "up", "down"]
var direction_current = direction_bat_facing[1]
var time_between_soundwaves = 0.5
var can_shoot_soundwave = true
var left_marker_tiles
var right_marker_tiles
var left_setpoint
var right_setpoint
var used_cells = []
var marker_tiles


func _ready() -> void:
	LevelManager.load_data()
	position = LevelManager.player_position


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not is_on_ceiling() and not is_on_wall():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("ui_up"):
		velocity.y = JUMP_VELOCITY
		direction_current = direction_bat_facing[2]
	elif Input.is_action_pressed("ui_down") and is_on_wall():
		velocity.y = -JUMP_VELOCITY
		direction_current = direction_bat_facing[3]
	elif Input.is_action_just_pressed("ui_down") and is_on_ceiling():
		velocity.y = -JUMP_VELOCITY
		direction_current = direction_bat_facing[3]
	else:
		if is_on_wall():
			velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction == -1:
			direction_current = direction_bat_facing[0]
		elif direction == 1:
			direction_current = direction_bat_facing[1]
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("fire_soundwave"):
		if can_shoot_soundwave:
			summon_soundwave()
			soundwave_timer.start(time_between_soundwaves)
			can_shoot_soundwave = false
			var creatures = get_tree().get_nodes_in_group("creatures")
			for creature in creatures:
				creature.alert_position()
	
	if Input.is_action_just_pressed("interact"):
		var current_position = info_tilemap.local_to_map(bat_body.global_position)
		var info : TileData = info_tilemap.get_cell_tile_data(current_position)
		if info:
			var can_sleep = info.get_custom_data("can_sleep")
			if can_sleep:
				print("SLEEP")
				LevelManager.player_position = position
				LevelManager.save_data()
	move_and_slide()


func summon_soundwave():
	var soundwave = soundwave_scene.instantiate()
	if direction_current == direction_bat_facing[0]:
		soundwave.position = right_soundwave_spawn.global_position
	elif direction_current == direction_bat_facing[1]:
		soundwave.position = left_soundwave_spawn.global_position
	else:
		soundwave.position = up_down_soundwave_spawn.global_position
	soundwave.rotation_degrees = 0
	soundwave.direction_facing = direction_current
	add_sibling(soundwave)


func _on_soundwave_timer_timeout() -> void:
	can_shoot_soundwave = true
