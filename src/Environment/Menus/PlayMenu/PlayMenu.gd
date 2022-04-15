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

var options = []
var optionsIndex = 0

func _ready():
	options.append(tutorialButton)
	options.append(archaeologistButton)
	options.append(dudeButton)
	options.append(musicianButton)
	options.append(painterButton)
	options.append(pilotButton)
	options.append(witchButton)
	options.append(backButton)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var _ignore = get_tree().change_scene(mainMenuPath)
	elif Input.is_action_just_pressed("ui_up"):
		move_up()
	elif Input.is_action_just_pressed("ui_down"):
		move_down()
	elif Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		move_side()

func move_up():
	options[optionsIndex].unselect()
	if optionsIndex == 0:
		optionsIndex = options.size() - 1
	else:
		optionsIndex -= 1
	options[optionsIndex].select()

func move_down():
	options[optionsIndex].unselect()
	if optionsIndex == options.size() - 1:
		optionsIndex = 0
	else:
		optionsIndex += 1
	options[optionsIndex].select()

func move_side():
	options[optionsIndex].unselect()
	if optionsIndex < options.size() / 2:
		optionsIndex += 4
	else:
		optionsIndex -= 4
	options[optionsIndex].select()
