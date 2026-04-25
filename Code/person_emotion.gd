extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame =  2

	Globals.EmotionChange.connect(_on_emotion_change)


func _on_emotion_change() -> void:
	var score: float = Globals.GameValues.EmotionScore
	
	if score >= 100:
		frame = 0  # very happy
	elif score >= 75:
		frame = 1  # happy
	elif score >= 50:
		frame = 2  # neutral
	elif score >= 25:
		frame = 3  # sad
	else:
		frame = 4  # angry
