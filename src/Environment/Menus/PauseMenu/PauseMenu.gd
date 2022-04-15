extends MarginContainer

onready var continueButton = $CenterContainer/VBoxContainer/ContinueButton
onready var quitButton = $CenterContainer/VBoxContainer/QuitButton

func _ready():
	visible = false

func _process(_delta):
	if Input.is_action_just_pressed("pause_play"):
		pause_unpause()
	elif Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
		change_selection()

func pause_unpause():
	visible = !visible
	get_tree().paused = !get_tree().paused

func change_selection():
	if continueButton.is_selected():
		continueButton.unselect()
	else:
		continueButton.select()

	if quitButton.is_selected():
		quitButton.unselect()
	else:
		quitButton.select()
