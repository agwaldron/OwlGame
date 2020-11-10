extends ColorRect

onready var label = $GameOverText

var fading = false
var transparency = 0.0
var fadespeed = 1.5

func _process(delta):
	if fading:
		transparency += (delta * fadespeed)
		if transparency >= 1:
			color = Color(0, 0, 0, 1)
			fading = false
			label.visible = true
		else:
			color = Color(0, 0, 0, transparency)

func fadeIn():
	fading = true
