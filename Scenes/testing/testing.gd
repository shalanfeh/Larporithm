extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.GameValues.Preference._Randomize()
	print("randomization test:")
	print(Globals.GameValues.Preference.preferences)
	pass # Replace with function body.
