extends Control

var genre_rows := {}

func _ready() -> void:
	genre_rows = {
		"education": $VBoxContainer/EducationRow/ProgressBar,
		"political": $VBoxContainer/PoliticalRow/ProgressBar,
		"gaming": $VBoxContainer/GamingRow/ProgressBar,
		"music": $VBoxContainer/MusicRow/ProgressBar,
		"drama": $VBoxContainer/DramaRow/ProgressBar,
		"sports": $VBoxContainer/SportsRow/ProgressBar,
		"technology": $VBoxContainer/TechnologyRow/ProgressBar,
		"health": $VBoxContainer/HealthRow/ProgressBar
	}

	Globals.AnalyticsChange.connect(update_bars)
	update_bars()


func update_bars() -> void:
	var count = max(Globals.GameValues.VideosWatched, 1)

	for genre in genre_rows.keys():
		var average = float(Globals.GameValues.GenreTotals.get(genre, 0)) / float(count)
		genre_rows[genre].value = clamp(average, 0, 100)
