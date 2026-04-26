extends Node
class_name AIHandler

signal title_evaluated(scores: Dictionary)
signal evaluation_failed(message: String)

const MODEL := "inclusionai/ling-2.6-1t:free"
const API_URL := "https://openrouter.ai/api/v1/chat/completions"
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

	var response_text := body.get_string_from_utf8()

	if response_code != 200:
		print(response_text)
		evaluation_failed.emit("API error: " + str(response_code))
		return

	var response: Variant = JSON.parse_string(response_text)
	if response == null or not response is Dictionary:
		evaluation_failed.emit("Could not parse API response.")
		return

	# OpenRouter format
	if not response.has("choices") or response["choices"].is_empty():
		print("Unexpected response: ", response)
		evaluation_failed.emit("No choices returned.")
		return

	var ai_text: String = response["choices"][0]["message"]["content"]
	print("Raw output: ", ai_text)

	# Clean possible markdown
	ai_text = ai_text.strip_edges()
	if ai_text.begins_with("```"):
		ai_text = ai_text.trim_prefix("```json").trim_prefix("```").trim_suffix("```").strip_edges()

	var scores: Variant = JSON.parse_string(ai_text)
	if scores == null or not scores is Dictionary:
		evaluation_failed.emit("Could not parse score JSON.")
		return

	title_evaluated.emit(scores)
