extends MarginContainer

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
	pass

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var _ignore = get_tree().change_scene(mainMenuPath)
