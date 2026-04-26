extends Node

signal GameStart()
signal GameEnd()

signal InputEntered(Entered: String)

signal NewVideoDisplayed()
signal ThumbnailDisplayed()

signal EmotionChange()

signal TimeChange()

var GameValues: GameState = GameState.new()
