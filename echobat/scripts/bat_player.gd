extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var soundwave_scene: PackedScene ## The soundwave that the bat shoots
@export var soundwave_spawn: Node2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("fire_soundwave"):
		print("POW")
		var soundwave = soundwave_scene.instantiate()
		soundwave.position = soundwave_spawn.global_position
		soundwave.rotation = $Node2D.rotation
		add_sibling(soundwave)
	move_and_slide()
