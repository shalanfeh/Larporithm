extends AnimatedSprite2D

@onready var MoodLabel: Label = $MoodLabel

var _base_scale: Vector2
var _last_frame: int = -1
var _pulse_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void: # Listen for time updates
	_base_scale = scale
	frame =  2
	Globals.EmotionChange.connect(_on_emotion_change)
	Globals.TimeChange.connect(_on_emotion_change)
	_on_emotion_change()

# Updates face based on how the viewer feels.
func _on_emotion_change() -> void:
	var mood: float = Globals.GameValues.EmotionScore
	var next_frame: int = 2
	
	# Sprite order: angry, sad, neutral, happy, very happy.
	if mood >= 80:
		next_frame = 4
	elif mood >= 60:
		next_frame = 3
	elif mood >= 40:
		next_frame = 2
	elif mood >= 20:
		next_frame = 1
	else:
		next_frame = 0
	
	if _last_frame != -1 and next_frame != _last_frame:
		pulse_reaction()
	
	frame = next_frame
	_last_frame = next_frame
	
	MoodLabel.text = "Mood: " + get_mood_label(mood)

func pulse_reaction() -> void:
	if _pulse_tween and _pulse_tween.is_valid():
		_pulse_tween.kill()
		scale = _base_scale
	
	_pulse_tween = create_tween()
	_pulse_tween.tween_property(self, "scale", _base_scale * 1.08, 0.08)
	_pulse_tween.tween_property(self, "scale", _base_scale, 0.14)

func get_mood_label(mood: float) -> String:
	if mood >= 80:
		return "delighted"
	if mood >= 60:
		return "interested"
	if mood >= 40:
		return "uncertain"
	if mood >= 20:
		return "frustrated"
	return "angry"
