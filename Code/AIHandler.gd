extends Node
class_name AIHandler

signal title_evaluated(scores: Dictionary)
signal evaluation_failed(message: String)

const MODEL := "inclusionai/ling-2.6-1t:free"
const API_URL := "https://openrouter.ai/api/v1/chat/completions"
const REQUEST_TIMEOUT := 15.0

var http_request: HTTPRequest
var pending_title: String = ""

const FALLBACK_KEYWORDS: Dictionary = {
	"education": ["learn", "school", "teacher", "documentary", "science", "history", "explained", "college"],
	"political": ["politics", "political", "election", "debate", "president", "government", "policy"],
	"gaming": ["game", "gaming", "minecraft", "fortnite", "roblox", "speedrun", "gameplay", "streamer"],
	"music": ["music", "song", "album", "singer", "concert", "rap", "guitar"],
	"drama": ["drama", "fight", "exposed", "scandal", "argument", "breakup", "angry"],
	"sports": ["sports", "soccer", "football", "nba", "basketball", "nfl", "goal", "dunk"],
	"technology": ["tech", "technology", "ai", "robot", "coding", "software", "iphone", "computer"],
	"health": ["health", "workout", "fitness", "gym", "diet", "doctor", "wellness", "running"]
}

func _ready() -> void:
	http_request = HTTPRequest.new()
	http_request.timeout = REQUEST_TIMEOUT
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	Globals.InputEntered.connect(_on_input_entered)

func _on_input_entered(entered: String) -> void:
	print("Sending title to model: ", entered)
	evaluate_title(entered)

func evaluate_title(title: String) -> void:
	pending_title = title
	var prompt := """You are evaluating a player-created YouTube title for a game.

Distribute exactly 100 integer points across the 8 genres based on how strongly the title fits each one.

Genres:
- education
- political
- gaming
- music
- drama
- sports
- technology
- health

Rules:
- Total MUST equal exactly 100
- Integers only
- Use 0 if not applicable

Return ONLY JSON.

Player title: "%s"
""" % title

	var body := {
		"model": MODEL,
		"messages": [
			{
				"role": "user",
				"content": prompt
			}
		],
		# This replaces your Gemini schema enforcement
		"response_format": { "type": "json_object" },
		"temperature": 0.2
	}

	var headers := [
		"Content-Type: application/json",
		"Authorization: Bearer " + ApiKeys.AIKey,
		"HTTP-Referer: http://localhost",
		"X-Title: Godot AI Game"
	]

	var err := http_request.request(
		API_URL,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(body)
	)

	if err != OK:
		_emit_fallback_scores("Could not start request (err %d)." % err)

func _on_request_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		_emit_fallback_scores("Network error: result " + str(result))
		return

	var response_text := body.get_string_from_utf8()

	if response_code != 200:
		print(response_text)
		_emit_fallback_scores("API error: " + str(response_code))
		return

	var response: Variant = JSON.parse_string(response_text)
	if response == null or not response is Dictionary:
		_emit_fallback_scores("Could not parse API response.")
		return

	# OpenRouter format
	if not response.has("choices") or response["choices"].is_empty():
		print("Unexpected response: ", response)
		_emit_fallback_scores("No choices returned.")
		return

	var ai_text: String = response["choices"][0]["message"]["content"]
	print("Raw output: ", ai_text)

	# Clean possible markdown
	ai_text = ai_text.strip_edges()
	if ai_text.begins_with("```"):
		ai_text = ai_text.trim_prefix("```json").trim_prefix("```").trim_suffix("```").strip_edges()

	var scores: Variant = JSON.parse_string(ai_text)
	if scores == null or not scores is Dictionary:
		_emit_fallback_scores("Could not parse score JSON.")
		return

	title_evaluated.emit(scores)

func _emit_fallback_scores(message: String) -> void:
	print(message, " Using fallback scores.")
	evaluation_failed.emit(message)
	title_evaluated.emit(_fallback_scores(pending_title))

func _fallback_scores(title: String) -> Dictionary:
	var lowered_title: String = title.to_lower()
	var scores: Dictionary = {}
	var total: int = 0
	
	for genre in FALLBACK_KEYWORDS.keys():
		var score: int = 0
		for keyword in FALLBACK_KEYWORDS[genre]:
			if lowered_title.contains(String(keyword)):
				score += 20
		scores[genre] = score
		total += score
	
	if total == 0:
		scores["drama"] = 35
		scores["technology"] = 25
		scores["education"] = 20
		scores["gaming"] = 20
		total = 100
	
	var running: int = 0
	var keys: Array = scores.keys()
	for i in range(keys.size()):
		var key: String = String(keys[i])
		if i == keys.size() - 1:
			scores[key] = 100 - running
		else:
			scores[key] = roundi(float(scores[key]) / float(total) * 100.0)
			running += int(scores[key])
	
	return scores
