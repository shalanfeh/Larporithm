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

func _Randomize() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var keys = preferences.keys()
	keys.shuffle()

	# Decide distribution
	var high_count = rng.randi_range(1, 2)
	var low_count = rng.randi_range(2, 3)

	# Assign HIGH values
	for i in range(high_count):
		preferences[keys[i]] = rng.randi_range(75, 100)

	# Assign LOW values
	for i in range(high_count, high_count + low_count):
		preferences[keys[i]] = rng.randi_range(0, 25)

	# Assign MID values
	for i in range(high_count + low_count, keys.size()):
		preferences[keys[i]] = rng.randi_range(35, 65)

	# Small random tweak so values aren't too uniform
	for key in keys:
		var tweak = rng.randi_range(-5, 5)
		preferences[key] = clamp(preferences[key] + tweak, 0, 100)
