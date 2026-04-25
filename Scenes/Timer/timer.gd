extends TextureProgressBar

@export var TimeKeeper: Timer

#for smoothing
@export var Multiplier: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = Globals.GameValues.TimeLeft * Multiplier
	value = Globals.GameValues.TimeLeft * Multiplier
	
	TimeKeeper.wait_time = Globals.GameValues.TickSpeed
	TimeKeeper.timeout.connect(Timeout)
	TimeKeeper.start()

func Timeout() -> void:
	Globals.GameValues.TimeLeft -= 1
	TimeKeeper.wait_time = Globals.GameValues.TickSpeed
	Globals.TimeChange.emit()

func _process(delta: float) -> void:
	value = lerp(value, Globals.GameValues.TimeLeft*10, 0.1)
