extends Node

# Reference to AIHandler (emits title_evaluated signal)
@export var ai_handler: Node

# Reference to timer script (must have add_time function)
@export var timer_manager: Node


func _ready() -> void:
	# Connect to AI output signal
	ai_handler.title_evaluated.connect(_on_title_evaluated)


# Called when AI returns genre scores for a title
func _on_title_evaluated(scores: Dictionary) -> void:
	# Get current audience preferences
	var preferences = Globals.GameValues.Preferences.preferences

	# Compare AI scores vs preferences
	var match_score := calculate_match_score(scores, preferences)

	# Convert match score into time adjustment
	var time_change := get_time_change(match_score)

	print("Match score: ", match_score)
	print("Time change: ", time_change)

	# Apply time change to timer
	timer_manager.add_time(time_change)


# Calculates how well AI scores match audience preferences (0–100)
func calculate_match_score(scores: Dictionary, preferences: Dictionary) -> float:
	var total_difference := 0.0

	for genre in preferences.keys():
		var ai_value: int = scores.get(genre, 0)
		var pref_value: int = preferences.get(genre, 0)

		# Sum absolute difference per genre
		total_difference += abs(ai_value - pref_value)

	# Max possible difference (used to normalize score)
	var max_difference := 200.0

	# Convert difference → similarity score (higher = better match)
	var match_score := 100.0 - ((total_difference / max_difference) * 100.0)

	return clamp(match_score, 0.0, 100.0)


# Maps match score to time change (game impact)
func get_time_change(match_score: float) -> int:
	if match_score >= 85:
		return 10 # great
	elif match_score >= 70:
		return 5 # decent
	elif match_score >= 45:
		return 0 # meh
	elif match_score >= 25:
		return -5 # bad
	else:
		return -10 # really bad
