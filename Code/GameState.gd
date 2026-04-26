class_name GameState

enum VideoPositions {TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT}

var TimeLeft: float = 60 #time left on timer
var MaxTime: float = TimeLeft
var TickSpeed: float = 1 #timer speed

var Started: bool = false #is timer ticking?

var GameStarted: bool = false
var GameOver: bool = false #game over, timer hit 0

var CurrentlyDisplayingVideo: bool = false
var ThumbnailDisplayed: bool = false
var ThumbnailPosition: VideoPositions

var Preference: Preferences
var AnalyticPreferences: Dictionary[String, int] = {
	"drama" = 50,
	"education" = 50,
	"gaming" = 50,
	"health" = 50,
	"music" = 50,
	"political" = 50,
	"sports" = 50,
	"technology" = 50
}

var EmotionScore: float = 50  #neutral
var BadRecommendationStreak: int = 0
var GoodRecommendationStreak: int = 0

var VideosWatched: int = 0

func _init() -> void:
	Preference = Preferences.new()
