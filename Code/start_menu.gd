extends Control

@export var Animator: AnimationPlayer
@export var StartButton: Button

@onready var PanelBox: Panel = $TheMenu/Panel
@onready var Title: RichTextLabel = $TheMenu/Title
@onready var Tagline: RichTextLabel = $TheMenu/Tagline

func _ready() -> void:
	Animator.play("MenuFlyIn")
	StartButton.pressed.connect(StartButtonPressed)
	Globals.GameEnd.connect(GameEnded)
	ShowStartScreen()

func StartButtonPressed() -> void:
	if Globals.GameValues.GameOver:
		Globals.RestartGame()
		Globals.TimeChange.emit()
		Globals.AnalyticChange.emit()
		Globals.EmotionChange.emit()
		ShowStartScreen()
	
	if Globals.GameValues.GameStarted == false:
		Globals.GameValues.GameStarted = true
		StartButton.text = "Start!"
		Animator.play("MenuFlyOut")
		Globals.GameStart.emit()

func GameEnded() -> void:
	ShowEndScreen()
	Animator.play("MenuFlyIn")

func ShowStartScreen() -> void:
	PanelBox.position = Vector2(361, 197)
	PanelBox.size = Vector2(433, 276)
	Title.position = Vector2(422, 143)
	Title.size = Vector2(314, 207)
	Title.add_theme_font_size_override("bold_font_size", 50)
	Tagline.position = Vector2(400, 292)
	Tagline.size = Vector2(356, 72)
	Tagline.add_theme_font_size_override("normal_font_size", 16)
	StartButton.position = Vector2(487, 382)
	StartButton.size = Vector2(178, 55)
	Title.text = "\n[center][b][wave amp=50 freq=5] [rainbow freq=0.2 sat=1 val=1] Larporithm [/rainbow] [/wave][/b][/center] \n "
	Tagline.text = "[center][wave][i]You are the algorithm.[/i][/wave]\nFind the hidden tastes before time runs out.[/center]"
	StartButton.text = "Start!"

func ShowEndScreen() -> void:
	PanelBox.position = Vector2(276, 92)
	PanelBox.size = Vector2(600, 464)
	Title.position = Vector2(308, 120)
	Title.size = Vector2(536, 72)
	Title.add_theme_font_size_override("bold_font_size", 38)
	Tagline.position = Vector2(326, 198)
	Tagline.size = Vector2(500, 238)
	Tagline.add_theme_font_size_override("normal_font_size", 20)
	StartButton.position = Vector2(466, 462)
	StartButton.size = Vector2(220, 60)
	
	var mood := int(Globals.GameValues.EmotionScore)
	Title.text = "[center][b]Session Complete[/b][/center]"
	Tagline.text = "[center][b]Final mood: %d - %s[/b]\nMood was your feedback signal.\n\nActual likes: %s\nActual dislikes: %s\nYour best guesses: %s\nVideos tested: %d[/center]" % [
		mood,
		get_mood_label(mood),
		join_words(Globals.GameValues.Preference.liked_genres),
		join_words(Globals.GameValues.Preference.disliked_genres),
		join_words(get_top_learned_genres()),
		Globals.GameValues.VideosWatched
	]
	StartButton.text = "Try Again"

func get_mood_label(mood: int) -> String:
	if mood >= 80:
		return "delighted"
	if mood >= 60:
		return "interested"
	if mood >= 40:
		return "uncertain"
	if mood >= 20:
		return "frustrated"
	return "angry"

func get_top_learned_genres() -> Array[String]:
	var keys := Globals.GameValues.AnalyticPreferences.keys()
	keys.sort_custom(func(a, b): return Globals.GameValues.AnalyticPreferences[a] > Globals.GameValues.AnalyticPreferences[b])
	var top: Array[String] = []
	for i in min(3, keys.size()):
		top.append(keys[i])
	return top

func join_words(words: Array[String]) -> String:
	var text := ""
	for i in range(words.size()):
		if i > 0:
			text += ", "
		text += words[i]
	return text
