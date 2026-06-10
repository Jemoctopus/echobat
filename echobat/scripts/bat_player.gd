extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -350.0

@export var soundwave_scene: PackedScene ## The soundwave that the bat shoots
@export var right_soundwave_spawn: Node2D ## The right marker in which we spawn the soundwaves from 
@export var left_soundwave_spawn: Node2D ## The left marker in which we spawn the soundwaves from 
@export var bat_body: Node2D ## The bats body in which we play visuals and locate the directions
@export var soundwave_timer: Timer ## The timer which times time inbetween soundwave


var direction_bat_facing = ["left", "right"]
var direction_current = direction_bat_facing[1]
var angle = 0
var time_between_soundwaves = 2
var can_shoot_soundwave = true
var soundwave_directions = {
	"left" : 0,
	"right" : 0,
	"up" : 90,
	"down": 270
}


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not is_on_ceiling() and not is_on_wall():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("ui_up"):
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("ui_down") and is_on_wall():
		velocity.y = -JUMP_VELOCITY
	elif Input.is_action_just_pressed("ui_down") and is_on_ceiling():
		velocity.y = -JUMP_VELOCITY
	else:
		if is_on_wall():
			velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction == 1:
			direction_current = direction_bat_facing[0]
			angle = soundwave_directions["left"]
		elif direction == -1:
			direction_current = direction_bat_facing[1]
			angle = soundwave_directions["right"]
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("fire_soundwave"):
		if can_shoot_soundwave:
			summon_soundwave(angle)
			soundwave_timer.start(time_between_soundwaves)
			can_shoot_soundwave = false
	move_and_slide()


func summon_soundwave(angle):
	var soundwave = soundwave_scene.instantiate()
	if direction_current == direction_bat_facing[0]:
		soundwave.position = right_soundwave_spawn.global_position
	elif direction_current == direction_bat_facing[1]:
		soundwave.position = left_soundwave_spawn.global_position
	soundwave.rotation_degrees = angle
	soundwave.direction_facing = direction_current
	add_sibling(soundwave)


func _on_soundwave_timer_timeout() -> void:
	can_shoot_soundwave = true
