extends TextureProgressBar

@export var TimeKeeper: Timer
@export var Text: Label
@export var SoundMaker: AudioStreamPlayer
@export var GameEndSFX: AudioStreamPlayer

#for smoothing
@export var Multiplier: int = 10

@export_category("Text Shake")
@export var shake_intensity: float = 4.0
@export var shake_duration: float = 0.3
@export var shake_steps: int = 12  # how many jitter movements during the shake
@export var ShakeStart: int = 10

@export_category("Colors!")
@export var color_full: Color = Color.GREEN
@export var color_mid: Color = Color.YELLOW
@export var color_empty: Color = Color.RED

var _original_position: Vector2
var _active_tween: Tween

var LerpingVal: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = Globals.GameValues.TimeLeft * Multiplier
	value = Globals.GameValues.TimeLeft * Multiplier
	
	LerpingVal = max_value
	
	UpdateText()
	Globals.TimeChange.connect(TimeChanged)
	_original_position = Text.position
	
	TimeKeeper.wait_time = Globals.GameValues.TickSpeed
	TimeKeeper.timeout.connect(Timeout)
	TimeKeeper.stop()
	
	Globals.GameStart.connect(GameStarted)
	Globals.GameEnd.connect(GameEnded)

func GameStarted() -> void:
	TimeKeeper.start()

func GameEnded() -> void:
	GameEndSFX.play()
	TimeKeeper.stop()

func Timeout() -> void:
	if Globals.GameValues.TimeLeft <= 6:
		PlayTick()
	
	Globals.GameValues.TimeLeft = Globals.GameValues.TimeLeft - 1
	TimeKeeper.wait_time = Globals.GameValues.TickSpeed
	Globals.TimeChange.emit()

func TimeChanged() -> void:
	UpdateText()

func UpdateText() -> void:
	var NewText: String = str(int(round(Globals.GameValues.TimeLeft)))
	NewText += ""
	
	if Globals.GameValues.TimeLeft <= 0:
		NewText = "Game\nOver!"
	
	Text.text = NewText
	shake()

func shake() -> void:
	# Kill any in-progress shake so we start clean
	var ShakeAmount: float = max(ShakeStart - Globals.GameValues.TimeLeft, 0)
	var ShakeMultiplier: float = (ShakeAmount)*0.75
	
	if ShakeAmount == 0: 
		ShakeMultiplier = 0
	
	if _active_tween and _active_tween.is_valid():
		_active_tween.kill()
		Text.position = _original_position

	_active_tween = create_tween()
	var step_duration := shake_duration / shake_steps

	for i in shake_steps:
		var offset := Vector2(
			randf_range(-shake_intensity*ShakeMultiplier, shake_intensity*ShakeMultiplier),
			randf_range(-shake_intensity*ShakeMultiplier, shake_intensity*ShakeMultiplier)
		)
		_active_tween.tween_property(Text, "position", _original_position + offset, step_duration)

	# Snap back at the end
	_active_tween.tween_property(Text, "position", _original_position, step_duration)

# Returns the blended color for a value in [0.0, 1.0]
# 1.0 = full (color A), 0.5 = midpoint (color B), 0.0 = empty (color C)
func get_color_for_value(t: float) -> Color:
	t = clamp(t, 0.0, 1.0)
	if t >= 0.5:
		# Top half: remap [0.5, 1.0] → [0.0, 1.0], then lerp B → A
		var sub_t := (t - 0.5) / 0.5
		return color_mid.lerp(color_full, sub_t)
	else:
		# Bottom half: remap [0.0, 0.5] → [0.0, 1.0], then lerp C → B
		var sub_t := t / 0.5
		return color_empty.lerp(color_mid, sub_t)

func PlayTick():
	SoundMaker.pitch_scale = randf_range(0.9, 1.1)
	SoundMaker.play()

func _process(delta: float) -> void:
	LerpingVal = lerp(LerpingVal, Globals.GameValues.TimeLeft*Multiplier, 0.1)
	value = LerpingVal
	
	var PercentLeft: float = LerpingVal/max_value
	tint_progress = get_color_for_value(PercentLeft)
	if PercentLeft < 0.25:
		Text.modulate = Text.modulate.lerp(get_color_for_value(PercentLeft), 0.1)
	else:
		Text.modulate = Color.WHITE
