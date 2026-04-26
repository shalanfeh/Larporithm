extends Control
class_name InfoBar

@export var Text: Label

func SetText(Words: String) -> void:
	Text.text = Words
