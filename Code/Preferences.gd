class_name Preferences

var preferences: Dictionary[String, int] = {
	"education": 0,
	"political": 0,
	"gaming": 0,
	"music": 0,
	"drama": 0,
	"sports": 0,
	"technology": 0,
	"health": 0
}

func _init() -> void:
	preferences = {
		"education": 0,
		"political": 0,
		"gaming": 0,
		"music": 0,
		"drama": 0,
		"sports": 0,
		"technology": 0,
		"health": 0
	}
	_Randomize()

func _Randomize() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var keys = preferences.keys()
	keys.shuffle()

	var high_count = rng.randi_range(1, 2)
	var low_count = rng.randi_range(2, 3)
	var raw: Dictionary = {}

	# Assign HIGH values
	for i in range(high_count):
		raw[keys[i]] = rng.randi_range(75, 100)

	# Assign LOW values
	for i in range(high_count, high_count + low_count):
		raw[keys[i]] = rng.randi_range(0, 25)

	# Assign MID values
	for i in range(high_count + low_count, keys.size()):
		raw[keys[i]] = rng.randi_range(35, 65)

	# Small random tweak
	for key in keys:
		var tweak = rng.randi_range(-5, 5)
		raw[key] = clamp(raw[key] + tweak, 0, 100)

	# Normalize so all values sum to 100
	var total: int = 0
	for key in keys:
		total += raw[key]

	var running_sum: int = 0
	for i in range(keys.size() - 1):
		var normalized = int(round(float(raw[keys[i]]) / float(total) * 100.0))
		preferences[keys[i]] = normalized
		running_sum += normalized

	# Last key gets the remainder to guarantee exact sum of 100
	preferences[keys[keys.size() - 1]] = 100 - running_sum
