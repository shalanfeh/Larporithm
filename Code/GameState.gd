class_name GameState

enum VideoPositions {TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT}

var TimeLeft: float = 15 #time left on timer
var TickSpeed: float = 1 #timer speed

var Started: bool = false #is timer ticking?
var GameOver: bool = false #game over, timer hit 0

var CurrentlyDisplayingVideo: bool = false
var ThumbnailDisplayed: bool = false
var ThumbnailPosition: VideoPositions

var Preference: Preferences = Preferences.new()
var EmotionScore: float = 50  #neutral
