class_name Preferences

const GENRES: Array[String] = [
	"education",
	"political",
	"gaming",
	"music",
	"drama",
	"sports",
	"technology",
	"health"
]

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
var liked_genres: Array[String] = []
var disliked_genres: Array[String] = []

func _init() -> void:
	for genre in GENRES:
		preferences[genre] = 50
	_Randomize()

func _Randomize() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var keys: Array[String] = []
	keys.append_array(GENRES)
	keys.shuffle()

	liked_genres.clear()
	disliked_genres.clear()
	
	var like_count := rng.randi_range(2, 3)
	var dislike_count := rng.randi_range(2, 3)
	
	for i in range(like_count):
		var genre := keys[i]
		liked_genres.append(genre)
		preferences[genre] = rng.randi_range(80, 100)
	
	for i in range(like_count, like_count + dislike_count):
		var genre := keys[i]
		disliked_genres.append(genre)
		preferences[genre] = rng.randi_range(0, 15)
	
	for i in range(like_count + dislike_count, keys.size()):
		preferences[keys[i]] = rng.randi_range(35, 65)

func LikesGenre(genre: String) -> bool:
	return liked_genres.has(genre)

func DislikesGenre(genre: String) -> bool:
	return disliked_genres.has(genre)
