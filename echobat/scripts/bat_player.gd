extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var soundwave_scene: PackedScene ## The soundwave that the bat shoots
@export var right_soundwave_spawn: Node2D ## The right marker in which we spawn the soundwaves from 
@export var left_soundwave_spawn: Node2D ## The left marker in which we spawn the soundwaves from 
@export var bat_body: Node2D ## The bats body in which we play visuals and stuff

var direction_bat_facing = ["left", "right"]
var direction_current = direction_bat_facing[1]
var angle = 0
var angle_list = [15]
var soundwave_directions = {
	"left" : 0,
	"right" : 180,
	"up" : 90,
	"down": 270
}


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = JUMP_VELOCITY

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
		for i in angle_list:
			var top_angle = angle
			var bottom_angle = angle
			top_angle += i
			bottom_angle -= i
			summon_soundwave(angle)
			summon_soundwave(top_angle)
			summon_soundwave(bottom_angle)
	move_and_slide()


func summon_soundwave(angle):
	var soundwave = soundwave_scene.instantiate()
	if direction_current == direction_bat_facing[0]:
		soundwave.position = right_soundwave_spawn.global_position
	elif direction_current == direction_bat_facing[1]:
		soundwave.position = left_soundwave_spawn.global_position
	soundwave.rotation_degrees = angle
	add_sibling(soundwave)
