extends Control

@export var Animator: AnimationPlayer
@export var StartButton: Button

func _ready() -> void:
	Animator.play("MenuFlyIn")
	StartButton.pressed.connect(StartButtonPressed)
	Globals.GameEnd.connect(GameEnded)

func StartButtonPressed() -> void:
	if (Globals.GameValues.GameStarted == false) or (Globals.GameValues.GameStarted == true and Globals.GameValues.GameOver == true):
		Globals.GameValues.GameStarted = true
		Animator.play("MenuFlyOut")
		Globals.GameStart.emit()

func GameEnded() -> void:
	Globals.RestartGame()
	Animator.play("MenuFlyIn")
	
