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
	"drama" = 0,
	"education" = 0,
	"gaming" = 0,
	"health" = 0,
	"music" = 0,
	"political" = 0,
	"sports" = 0,
	"technology" = 0
}

var EmotionScore: float = 50  #neutral

var VideosWatched: int = 0

func _init() -> void:
	Preference = Preferences.new()
