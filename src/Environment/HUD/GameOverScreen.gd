extends ColorRect

onready var label = $GameOverText

var fading = false
var transparency = 0.0
var fadespeed = 1.5
var mainmenutimer = 1.25
var mainmenupath = "res://src/Environment/Menus/MainMenu/MainMenu.tscn"

func _process(delta):
	if fading:
		transparency += (delta * fadespeed)
		if transparency >= 1:
			color = Color(0, 0, 0, 1)
			fading = false
			label.visible = true
			yield(get_tree().create_timer(mainmenutimer), "timeout")
			var _ignore = get_tree().change_scene(mainmenupath)
		else:
			color = Color(0, 0, 0, transparency)

func fadeIn():
	fading = true
