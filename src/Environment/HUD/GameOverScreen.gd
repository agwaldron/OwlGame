extends ColorRect

onready var label = $GameOverText

var fading = false
var transparency = 0.0
var fadeSpeed = 1.5
var mainMenuTimer = 1.25
var mainMenuPath = "res://src/Environment/Menus/MainMenu/MainMenu.tscn"

func _process(delta):
	if fading:
		transparency += (delta * fadeSpeed)
		if transparency >= 1:
			color = Color(0, 0, 0, 1)
			fading = false
			label.visible = true
			yield(get_tree().create_timer(mainMenuTimer), "timeout")
			var _ignore = get_tree().change_scene(mainMenuPath)
		else:
			color = Color(0, 0, 0, transparency)

func fade_in():
	fading = true
