extends MarginContainer

onready var playButton = $CenterContainer/VBoxContainer/Play
onready var exitButton = $CenterContainer/VBoxContainer/Exit

var options = []
var optionsIndex = 0

func _ready():
	options.append(playButton)
	options.append(exitButton)

func _process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		move_up()
	elif Input.is_action_just_pressed("ui_down"):
		move_down()

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
