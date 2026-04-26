extends Node

signal GameStart()
signal GameEnd()

signal InputEntered(Entered: String)

signal EmotionChange()

signal TimeChange()

signal AnalyticChange()

var GameValues: GameState = GameState.new()

func RestartGame() -> void:
	GameValues = null
	GameValues = GameState.new()
