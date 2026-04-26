extends Control
class_name DoomScroll

@export var Animator: AnimationPlayer
@export var VidA: DoomVid
@export var VidB: DoomVid

func _ready() -> void:
	Globals.InputEntered.connect(InputGiven)
	pass

#false = A, true = B
var NewVidPtr: bool = true

func InputGiven(Entered: String) -> void:
	CreateNewVideo(Entered)
	DisplayNew()

func DisplayNew() -> void:
	match NewVidPtr:
		false: 
			Animator.play("ShowA")
			NewVidPtr = true
		true: 
			Animator.play("ShowB")
			NewVidPtr = false
	pass

func CreateNewVideo(NewVidTitle: String = "") -> void:
	match NewVidPtr:
		false:
			VidB.NewVideo(NewVidTitle)
		true:
			VidA.NewVideo(NewVidTitle)
	pass
