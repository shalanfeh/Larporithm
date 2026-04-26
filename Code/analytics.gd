extends Control

@export_category("Progress Bars")
@export var DramaBar: ProgressBar
@export var EducationBar: ProgressBar
@export var GamingBar: ProgressBar
@export var HealthBar: ProgressBar
@export var MusicBar: ProgressBar
@export var PoliticalBar: ProgressBar
@export var SportsBar: ProgressBar
@export var TechnologyBar: ProgressBar

var BarsArray: Dictionary[String, ProgressBar] = {
	"drama" = DramaBar,
	"education" = EducationBar,
	"gaming" = GamingBar,
	"health" = HealthBar,
	"music" = MusicBar,
	"political" = PoliticalBar,
	"sports" = SportsBar,
	"technology" = TechnologyBar
}

func _ready() -> void:
	BarsArray = {
		"drama" = DramaBar,
		"education" = EducationBar,
		"gaming" = GamingBar,
		"health" = HealthBar,
		"music" = MusicBar,
		"political" = PoliticalBar,
		"sports" = SportsBar,
		"technology" = TechnologyBar
	}
	
	
	for key in BarsArray:
		BarsArray[key].max_value = 0
		BarsArray[key].value = Globals.GameValues.AnalyticPreferences[key]


func _process(_delta: float) -> void:
	for key in BarsArray:
		BarsArray[key].max_value = lerp(BarsArray[key].max_value, float(Globals.GameValues.VideosWatched), 0.1)
		BarsArray[key].value = lerp(BarsArray[key].value, float(Globals.GameValues.AnalyticPreferences[key]), 0.1)
