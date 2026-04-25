extends TextureProgressBar

@export var TimeKeeper: Timer
@export var TimeLeft: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = TimeLeft
	TimeKeeper.start()
	TimeKeeper.timeout.connect(Timeout)
	print("hello")

func Timeout() -> void:
	print("beep")
	TimeLeft -= 1
	value = TimeLeft
	if TimeLeft <= 0:
		TimeKeeper.stop()
