extends Node2D

@export var Scroller: DoomScroll
@export var AIBro: AIHandler
@export var InfBar: InfoBar

var LastEvaluationWarning: String = ""

func _ready() -> void:
	Scroller.DisplayNew()
	AIBro.title_evaluated.connect(ProcessEvaluation)
	AIBro.evaluation_failed.connect(OnEvaluationFailed)
	Globals.EmotionChange.emit()
	#print(Globals.GameValues.Preference.preferences)

func OnEvaluationFailed(message: String) -> void:
	LastEvaluationWarning = message

func ProcessEvaluation(Scores: Dictionary) -> void:
	Globals.GameValues.VideosWatched += 1
	
	Scores = normalize_to_100(Scores)
	var Categories: Array[String] = get_top_3_keys(Scores)
	ApplyEmotion(Categories)
	
	

func ApplyEmotion(Categories: Array[String]) -> void:
	var Score: int = 0
	var liked: Array[String] = []
	var disliked: Array[String] = []
	
	for genre in Categories:
		if not Globals.GameValues.Preference.preferences.has(genre):
			continue
		
		if Globals.GameValues.Preference.LikesGenre(genre):
			Score += 20
			liked.append(genre)
		elif Globals.GameValues.Preference.DislikesGenre(genre):
			Score -= 10
			disliked.append(genre)
	
	if liked.size() == 0:
		Score -= 10
	if disliked.size() > 0:
		Score -= 3 * disliked.size()
	if liked.size() > 0 and disliked.size() == 0:
		Score += 6 * liked.size()
	
	var liked_video := Score > 0
	if liked_video:
		Globals.GameValues.GoodRecommendationStreak += 1
		Globals.GameValues.BadRecommendationStreak = 0
		Score += min(Globals.GameValues.GoodRecommendationStreak - 1, 2) * 4
	else:
		Globals.GameValues.BadRecommendationStreak += 1
		Globals.GameValues.GoodRecommendationStreak = 0
		Score -= min(Globals.GameValues.BadRecommendationStreak - 1, 3) * 12
	
	print(Score)
	
	Globals.GameValues.EmotionScore += Score
	Globals.GameValues.EmotionScore = clamp(Globals.GameValues.EmotionScore, 0, 100)
	
	var TimeChange: int = 0
	if liked_video:
		TimeChange = 5 + liked.size() * 3
	else:
		TimeChange = -4 - (Globals.GameValues.BadRecommendationStreak * 2) - (disliked.size() * 2)
	
	Globals.GameValues.TimeLeft += TimeChange
	Globals.GameValues.TimeLeft = clamp(Globals.GameValues.TimeLeft, 0, 60)
	Globals.TimeChange.emit()
	
	Globals.EmotionChange.emit()
	UpdateAnalytics(Categories, Score)
	
	var InfoText: String = "Video contained: " + join_words(Categories)
	if liked_video:
		InfoText += " | Mood improved"
	else:
		InfoText += " | Mood dropped"
	InfoText += " | Time " + signed_number(TimeChange)
	if LastEvaluationWarning != "":
		InfoText += " | Fallback mode used"
		LastEvaluationWarning = ""
	InfBar.SetText(InfoText)
	
	if Globals.GameValues.TimeLeft <= 0 and not Globals.GameValues.GameOver:
		Globals.GameValues.GameOver = true
		Globals.GameEnd.emit()

func UpdateAnalytics(categories: Array[String], reaction_score: int) -> void:
	var change: int = 0
	if reaction_score > 0:
		change = 14
	else:
		change = -14
	
	for genre in categories:
		if Globals.GameValues.AnalyticPreferences.has(genre):
			Globals.GameValues.AnalyticPreferences[genre] = clamp(
				Globals.GameValues.AnalyticPreferences[genre] + change,
				0,
				100
			)
	
	Globals.AnalyticChange.emit()

func signed_number(value: int) -> String:
	if value > 0:
		return "+" + str(value)
	return str(value)

func join_words(words: Array[String]) -> String:
	var text := ""
	for i in range(words.size()):
		if i > 0:
			text += ", "
		text += words[i]
	return text

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
