extends Node2D

@export var edge_scene: PackedScene
@export var marker: Node2D
@export var expiration_timer: Timer

var angles = 30
var expiration_time = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	expiration_timer.start(expiration_time)
	_summon_soundwave(angles)
	_summon_soundwave(-angles)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _summon_soundwave(angle) -> void:
	print("summoned")
	var soundwave_edge = edge_scene.instantiate()
	soundwave_edge.position = marker.position
	soundwave_edge.rotation_degrees = angle
	add_child(soundwave_edge)


func _on_expiration_timer_timeout() -> void:
	queue_free()
