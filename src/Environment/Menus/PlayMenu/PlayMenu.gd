extends MarginContainer

const tutorialPath = "res://src/Levels/Enemies.tscn"
const archaeologistArenaPath = "res://src/Levels/TheArchaeologistArena.tscn"
const dudeArenaPath = "res://src/Levels/TheDudeArena.tscn"
const musicianArenaPath = "res://src/Levels/TheMusicianArena.tscn"
const painterArenaPath = "res://src/Levels/ThePainterArena.tscn"
const pilotArenaPath = "res://src/Levels/ThePilotArena.tscn"
const witchArenaPath = "res://src/Levels/TheWitchArena.tscn"
const mainMenuPath = "res://src/Environment/Menus/MainMenu/MainMenu.tscn"

onready var tutorialButton = $CenterContainer/HBoxContainer/VBoxContainer/TutorialButton
onready var archaeologistButton = $CenterContainer/HBoxContainer/VBoxContainer/ArchaeologistButton
onready var dudeButton = $CenterContainer/HBoxContainer/VBoxContainer/DudeButton
onready var musicianButton = $CenterContainer/HBoxContainer/VBoxContainer/MusicianButton
onready var painterButton = $CenterContainer/HBoxContainer/VBoxContainer2/PainterButton
onready var pilotButton = $CenterContainer/HBoxContainer/VBoxContainer2/PilotButton
onready var witchButton = $CenterContainer/HBoxContainer/VBoxContainer2/WitchButton
onready var backButton = $CenterContainer/HBoxContainer/VBoxContainer2/BackButton

func _ready():
	tutorialButton.material.set_shader_param("selected", true)

func _on_TutorialButton_pressed():
	var _ignore = get_tree().change_scene(tutorialPath)

func _on_ArchaeologistButton_pressed():
	var _ignore = get_tree().change_scene(archaeologistArenaPath)

func _on_DudeButton_pressed():
	var _ignore = get_tree().change_scene(dudeArenaPath)

func _on_MusicianButton_pressed():
	var _ignore = get_tree().change_scene(musicianArenaPath)

func _on_PainterButton_pressed():
	var _ignore = get_tree().change_scene(painterArenaPath)

func _on_PilotButton_pressed():
	var _ignore = get_tree().change_scene(pilotArenaPath)

func _on_WitchButton_pressed():
	var _ignore = get_tree().change_scene(witchArenaPath)

func _on_BackButton_pressed():
	var _ignore = get_tree().change_scene(mainMenuPath)
