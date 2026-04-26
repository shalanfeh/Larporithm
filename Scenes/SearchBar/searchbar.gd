extends Control

@export var Intake: LineEdit
@export var EnterButton: Button

func _ready() -> void:
	Globals.GameStart.connect(OnGameStart)
	EnterButton.pressed.connect(SubmitEntered)
	Intake.text_submitted.connect(func(_entered: String): SubmitEntered())

func OnGameStart() -> void:
	Intake.grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action("Entered"):
		SubmitEntered()
		return
	
	if event.is_action("GrabFocus"):
		Intake.grab_focus()
		return

func SubmitEntered() -> void:
	if Intake.text.length() > 5:
		if ((Globals.GameValues.GameStarted == true) and (Globals.GameValues.GameOver == false)):
			Globals.InputEntered.emit(Intake.text)
			Intake.text = ""
