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

var optionsList = []
var optionsIndex = 0

func _ready():
	optionsList.append(tutorialButton)
	optionsList.append(archaeologistButton)
	optionsList.append(dudeButton)
	optionsList.append(musicianButton)
	optionsList.append(painterButton)
	optionsList.append(pilotButton)
	optionsList.append(witchButton)
	optionsList.append(backButton)

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
	optionsList[optionsIndex].unselect()
	if optionsIndex == 0:
		optionsIndex = optionsList.size() - 1
	else:
		optionsIndex -= 1
	optionsList[optionsIndex].select()

func move_down():
	optionsList[optionsIndex].unselect()
	if optionsIndex == optionsList.size() - 1:
		optionsIndex = 0
	else: 
		optionsIndex += 1
	optionsList[optionsIndex].select()

func move_side():
	optionsList[optionsIndex].unselect()
	if optionsIndex < optionsList.size() / 2:
		optionsIndex += 4
	else:
		optionsIndex -= 4
	optionsList[optionsIndex].select()
