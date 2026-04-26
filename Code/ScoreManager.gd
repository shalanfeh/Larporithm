extends Node

@export var ai_handler: Node
@export var timer_manager: Node

func _ready() -> void:
	ai_handler.title_evaluated.connect(_on_title_evaluated)

func _on_title_evaluated(scores: Dictionary) -> void:
	var preferences = Globals.GameValues.Preferences.preferences

	var match_score := calculate_match_score(scores, preferences)
	var time_change := get_time_change(match_score)

	print("Match score: ", match_score)
	print("Time change: ", time_change)

	timer_manager.add_time(time_change)

func calculate_match_score(scores: Dictionary, preferences: Dictionary) -> float:
	var total_difference := 0.0

	for genre in preferences.keys():
		var ai_value: int = scores.get(genre, 0)
		var pref_value: int = preferences.get(genre, 0)

		total_difference += abs(ai_value - pref_value)

	var max_difference := 200.0
	var match_score := 100.0 - ((total_difference / max_difference) * 100.0)

	return clamp(match_score, 0.0, 100.0)

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
