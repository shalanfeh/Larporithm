extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void: # Listen for time updates
	frame =  2
	Globals.TimeChange.connect(_on_time_change)

# Updates face based on remaining time
func _on_time_change() -> void:
	var time_left: float = Globals.GameValues.TimeLeft
	var game_time: float = Globals.GameValues.MaxTime
	
	# Map time ranges to emotional states
	if time_left >= (game_time) * (3/4):
		frame = 0 # very happy
	elif time_left >= (game_time) * (1/2):
		frame = 1 # happy
	elif time_left >= (game_time) * (1/3):
		frame = 2 # neutral
	elif time_left >= (game_time) * (1/6):
		frame = 3 # sad
	else:
		frame = 4 # angry
