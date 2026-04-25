extends Node

signal title_evaluated(scores: Dictionary)
signal evaluation_failed(message: String)

const MODEL := "gemma-4-26b-a4b-it"

var http_request: HTTPRequest


func _ready() -> void:
	http_request = HTTPRequest.new()
	add_child(http_request)

	http_request.request_completed.connect(_on_request_completed)

	Globals.InputEntered.connect(_on_input_entered)


func _on_input_entered(entered: String) -> void:
	print("Sending title to Gemma 4: ", entered)
	evaluate_title(entered)


func evaluate_title(title: String) -> void:
	var prompt := """
You are evaluating a player-created YouTube title for a game.

Score the title from 0 to 100 for each genre:
- sports
- tech
- drama
- politics

Rules:
- Higher score means the title strongly fits that genre.
- A title can score high in multiple genres.
- Use only integers from 0 to 100.
- Return only valid JSON.
- Do not include markdown.
- Do not include extra text.

Return this exact JSON structure:
{
  "sports": 0,
  "tech": 0,
  "drama": 0,
  "politics": 0,
  "reason": "short explanation"
}

Player title: "%s"
""" % title

	var url := "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s" % [
		MODEL,
		APIKeys.AIKey
	]

	var body := {
		"contents": [
			{
				"parts": [
					{ "text": prompt }
				]
			}
		]
	}

	var headers := ["Content-Type: application/json"]

	var err := http_request.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(body)
	)

	if err != OK:
		evaluation_failed.emit("Could not start Gemma request.")


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		print(body.get_string_from_utf8())
		evaluation_failed.emit("Gemma API error: " + str(response_code))
		return

	var response_text := body.get_string_from_utf8()
	var response = JSON.parse_string(response_text)

	if response == null:
		evaluation_failed.emit("Could not parse API response.")
		return

	var ai_text = response["candidates"][0]["content"]["parts"][0]["text"]
	print("Gemma raw output: ", ai_text)

	var scores = JSON.parse_string(ai_text)

	if scores == null:
		evaluation_failed.emit("Could not parse Gemma score JSON.")
		return

	title_evaluated.emit(scores)
