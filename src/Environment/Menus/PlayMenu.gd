extends MarginContainer

const tutorial = "res://src/Levels/Enemies.tscn"
const archaeologistarena = "res://src/Levels/TheArchaeologistArena.tscn"
const dudearena = "res://src/Levels/TheDudeArena.tscn"
const musicianarena = "res://src/Levels/TheMusicianArena.tscn"
const painterarena = "res://src/Levels/ThePainterArena.tscn"
const pilotarena = "res://src/Levels/ThePilotArena.tscn"
const witcharena = "res://src/Levels/TheWitchArena.tscn"
const mainmenu = "res://src/Environment/Menus/MainMenu.tscn"

func _on_TutorialButton_pressed():
	var _ignore = get_tree().change_scene(tutorial)

func _on_ArchaeologistButton_pressed():
	var _ignore = get_tree().change_scene(archaeologistarena)

func _on_DudeButton_pressed():
	var _ignore = get_tree().change_scene(dudearena)

func _on_MusicianButton_pressed():
	var _ignore = get_tree().change_scene(musicianarena)

func _on_PainterButton_pressed():
	var _ignore = get_tree().change_scene(painterarena)

func _on_PilotButton_pressed():
	var _ignore = get_tree().change_scene(pilotarena)

func _on_WitchButton_pressed():
	var _ignore = get_tree().change_scene(witcharena)

func _on_BackButton_pressed():
	var _ignore = get_tree().change_scene(mainmenu)
