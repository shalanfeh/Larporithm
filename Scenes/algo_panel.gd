extends ColorRect

var ShaderMat: ShaderMaterial = material

var rainbow: Array[Vector4] = [
	Vector4(0.8, 0.0, 0.0, 1.0),      # Red
	Vector4(0.8, 0.3, 0.0, 1.0),      # Orange
	Vector4(0.8, 0.8, 0.0, 1.0),      # Yellow
	Vector4(0.0, 0.8, 0.0, 1.0),      # Green
	Vector4(0.0, 0.0, 0.8, 1.0),      # Blue
	Vector4(0.15, 0.0, 0.3, 1.0),    # Indigo
	Vector4(0.3, 0.0, 0.8, 1.0),     # Violet
]

func _ready() -> void:
	cycle_shader_rainbow()

func _set_colour_1(v: Vector4) -> void:
	ShaderMat.set_shader_parameter("colour_1", v)

func cycle_shader_rainbow(duration_per_color: float = 0.5, loop: bool = true) -> void:
	var tween := create_tween()
	if loop:
		tween.set_loops()

	for i in rainbow.size():
		var from := rainbow[i]
		var to := rainbow[(i + 1) % rainbow.size()]
		tween.tween_method(_set_colour_1, from, to, duration_per_color)
