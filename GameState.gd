class_name GameState

enum Emotions {HAPPY, SMILE, NEUTRAL, FROWN, MAD}
enum VideoPositions {TOPLEFT, TOPRIGHT, BOTTOMLEFT, BOTTOMRIGHT}

var TimeLeft: float = 60 #time left on timer
var TickSpeed: float = 1 #timer speed

var Started: bool = false #is timer ticking?
var GameOver: bool = false #game over, timer hit 0

var CurrentlyDisplayingVideo: bool = false
var ThumbnailDisplayed: bool = false
var ThumbnailPosition: VideoPositions

var Preferences = {
	peak = 10
}
