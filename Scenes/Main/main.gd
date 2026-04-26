extends Node2D

@export var Scroller: DoomScroll
@export var AIBro: AIHandler
@export var InfBar: InfoBar

func _ready() -> void:
	Scroller.DisplayNew()
	AIBro.title_evaluated.connect(ProcessEvaluation)
	#print(Globals.GameValues.Preference.preferences)

func ProcessEvaluation(Scores: Dictionary) -> void:
	Globals.GameValues.VideosWatched += 1
	
	Scores = normalize_to_100(Scores)
	var Categories: Array[String] = get_top_3_keys(Scores)
	for genre in Categories:
		Globals.GameValues.AnalyticPreferences[genre] += 1
	
	Globals.AnalyticChange.emit()
	ApplyEmotion(Categories)
	
	

func ApplyEmotion(Categories: Array[String]) -> void:
	var Score: float = 0
	for genre in Categories:
		if Globals.GameValues.Preference.preferences[genre] >= 10:
			Score += Globals.GameValues.Preference.preferences[genre] - 10
		else:
			Score -= 5
	
	print(Score)
	
	Globals.GameValues.EmotionScore += Score
	Globals.GameValues.EmotionScore = clamp(Globals.GameValues.EmotionScore, 0, 100)
	
	if Score <= 5:
		Globals.GameValues.TimeLeft -= abs(Score)
	else:
		Globals.GameValues.TimeLeft += (Score * 3)
	Globals.GameValues.TimeLeft = clamp(Globals.GameValues.TimeLeft, 0, 60)
	Globals.TimeChange.emit()
	
	Globals.EmotionChange.emit()
	
	var InfoText: String = "Video contained: "
	for key in Categories:
		InfoText += key + ", "
	InfoText += " | Score: " + str(Score)
	InfBar.SetText(InfoText)

func get_top_3_keys(scores: Dictionary) -> Array[String]:
	var keys := scores.keys()
	keys.sort_custom(func(a, b): return scores[a] > scores[b])
	var top: Array[String] = []
	for i in min(3, keys.size()):
		top.append(keys[i])
	return top

func normalize_to_100(scores: Dictionary) -> Dictionary:
	var total: int = 0
	for k in scores: total += int(scores[k])
	if total == 0: return scores
	var out := {}
	var running := 0
	var keys := scores.keys()
	for i in keys.size():
		var k = keys[i]
		if i == keys.size() - 1:
			out[k] = 100 - running  # last key absorbs rounding
		else:
			out[k] = roundi(float(scores[k]) / total * 100.0)
			running += out[k]
	return out
