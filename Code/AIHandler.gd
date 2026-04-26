extends Node
class_name AIHandler

signal title_evaluated(scores: Dictionary)
signal evaluation_failed(message: String)

const MODEL := "gemini-2.5-flash-lite"
const REQUEST_TIMEOUT := 15.0

var http_request: HTTPRequest

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
	var prompt := """You are evaluating a player-created YouTube title for a game.
Distribute exactly 100 integer points across the 8 genres based on how strongly the title fits each one.
Higher points = stronger match. Use 0 for genres that do not apply. The total must equal exactly 100.

Player title: "%s" """ % title

	# Schema forces the API to return *only* this exact JSON shape.
	var response_schema := {
		"type": "OBJECT",
		"properties": {
			"education":  { "type": "INTEGER" },
			"political":  { "type": "INTEGER" },
			"gaming":     { "type": "INTEGER" },
			"music":      { "type": "INTEGER" },
			"drama":      { "type": "INTEGER" },
			"sports":     { "type": "INTEGER" },
			"technology": { "type": "INTEGER" },
			"health":     { "type": "INTEGER" },
		},
		"required": [
			"education", "political", "gaming", "music",
			"drama", "sports", "technology", "health"
		],
		"propertyOrdering": [
			"education", "political", "gaming", "music",
			"drama", "sports", "technology", "health"
		]
	}

	var url := "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s" % [
		MODEL,
		ApiKeys.AIKey
	]

	var body := {
		"contents": [
			{ "parts": [ { "text": prompt } ] }
		],
		"generationConfig": {
			"responseMimeType": "application/json",
			"responseSchema": response_schema,
			"temperature": 0.2,
			# Disable thinking on flash-lite for max speed
			"thinkingConfig": { "thinkingBudget": 0 }
		}
	}

	var headers := ["Content-Type: application/json"]
	var err := http_request.request(
		url, headers, HTTPClient.METHOD_POST, JSON.stringify(body)
	)
	if err != OK:
		evaluation_failed.emit("Could not start request (err %d)." % err)

func _on_request_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		evaluation_failed.emit("Network error: result " + str(result))
		return

	if response_code != 200:
		print(body.get_string_from_utf8())
		evaluation_failed.emit("API error: " + str(response_code))
		return

	var response_text := body.get_string_from_utf8()
	var response: Variant = JSON.parse_string(response_text)
	if response == null or not response is Dictionary:
		evaluation_failed.emit("Could not parse API response.")
		return

	# Defensive drilling — any missing key means an error/blocked response
	if not response.has("candidates") or response["candidates"].is_empty():
		print("Unexpected response: ", response)
		evaluation_failed.emit("No candidates returned.")
		return

	var ai_text: String = response["candidates"][0]["content"]["parts"][0]["text"]
	print("Raw output: ", ai_text)

	# Strip ```json fences just in case
	ai_text = ai_text.strip_edges()
	if ai_text.begins_with("```"):
		ai_text = ai_text.trim_prefix("```json").trim_prefix("```").trim_suffix("```").strip_edges()

	var scores: Variant = JSON.parse_string(ai_text)
	if scores == null or not scores is Dictionary:
		evaluation_failed.emit("Could not parse score JSON.")
		return

	title_evaluated.emit(scores)
