extends CanvasLayer


@export var pause_screen : Node
@export var score_counter : Label

var score_text = "Insects caught:"


func _ready() -> void:
	# Set settings
	pause_screen.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS


func _on_to_menu_button_down() -> void:
	# Quits to the menu.
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_resume_button_down() -> void:
	# Resumes the game.
	get_tree().paused = false
	pause_screen.visible = false


func _on_pause_button_button_down() -> void:
	# Pauses the game.
	pause_screen.visible = true
	get_tree().paused = true


func update_label() -> void:
	# Updates the insect score. 
	score_counter.text = score_text
