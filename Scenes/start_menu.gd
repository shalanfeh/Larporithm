extends Control


func _ready() -> void:
	$CenterContainer/VBoxContainer/StartButton.pressed.connect(_on_start_pressed)


func _on_start_pressed() -> void:
	# Switch to the main game scene
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
