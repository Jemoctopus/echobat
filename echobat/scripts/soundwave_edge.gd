extends Node2D

const SPEED = 1000
@export var expiry_timer: Timer
var time_till_expiry = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	expiry_timer.start(time_till_expiry)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_local_x(SPEED * delta)


func _on_timer_timeout() -> void:
	queue_free()
