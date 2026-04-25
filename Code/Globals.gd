extends Node

signal InputEntered(Entered: String)
signal NewVideoDisplayed()
signal ThumbnailDisplayed()


var GameState: GameState

func _ready():
	GameState.Preferences.peak
