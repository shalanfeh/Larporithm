extends Control
class_name DoomVid

@export var VideoName: RichTextLabel
@export var TuberName: RichTextLabel
@export var BG: ColorRect

var FirstWordBank: Array[String] = [
	"Devious",
	"Saintly",
	"Lying",
	"Truthy",
	"Lucky",
	"Dino",
	"Dog",
	"Husky",
	"Purple",
	"Jimbo",
	"Hacker",
	"Natural",
	""
]

var SecondWordBank: Array[String] = [
	"Toucher",
	"Generator",
	"Hacking",
	"Dosage",
	"Calamary",
	"Beast",
	"Furnace",
	"Snake",
	"Hallucination",
	"Intelligence",
	"Lacker",
	""
]

func RandomizeBGColor() -> void:
	var ShaderMat: ShaderMaterial = BG.material
	#colors
	if randi_range(0, 1) == 1:
		#normal
		ShaderMat.set_shader_parameter("colour_1", Vector4(randf_range(0.05, 0.8),randf_range(0.05, 0.8),randf_range(0.05, 0.8),1))
		ShaderMat.set_shader_parameter("colour_2", Vector4(randf_range(0.05, 0.8),randf_range(0.05, 0.8),randf_range(0.05, 0.8),1))
		ShaderMat.set_shader_parameter("colour_3", Vector4(randf_range(0.001, 0.05),randf_range(0.001, 0.05),randf_range(0.001, 0.05),1))
	else:
		#inverted
		ShaderMat.set_shader_parameter("colour_1", Vector4(randf_range(0.001, 0.05),randf_range(0.001, 0.05),randf_range(0.001, 0.05),1))
		ShaderMat.set_shader_parameter("colour_2", Vector4(randf_range(0.001, 0.05),randf_range(0.001, 0.05),randf_range(0.001, 0.05),1))
		ShaderMat.set_shader_parameter("colour_3", Vector4(randf_range(0.05, 0.8),randf_range(0.05, 0.8),randf_range(0.05, 0.8),1))
	
	#spinning
	if randi_range(0, 1) == 1:
		ShaderMat.set_shader_parameter("is_rotating", true)
	else:
		ShaderMat.set_shader_parameter("is_rotating", false)
		
	#static warp
	ShaderMat.set_shader_parameter("spin_amount", randf_range(0.1, 0.3))

func SetVideoName(VidName: String) -> void:
	VideoName.text = "[fade start=31] " + VidName
	pass

func NewVideo(VidName: String) -> void:
	SetVideoName(VidName)
	
	TuberName.text = "[b] @" + FirstWordBank[randi_range(0, FirstWordBank.size()-1)] + SecondWordBank[randi_range(0, SecondWordBank.size()-1)]
	if randi_range(0, 5) == 5:
		TuberName.text += str(randi_range(0,999))
	
	RandomizeBGColor()
	pass
