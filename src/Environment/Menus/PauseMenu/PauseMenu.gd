extends MarginContainer

onready var continueButton = $CenterContainer/VBoxContainer/ContinueButton
onready var quitButton = $CenterContainer/VBoxContainer/QuitButton

func _ready():
	visible = false

func _process(_delta):
	if Input.is_action_just_pressed("pause_play"):
		pause_unpause()

func pause_unpause():
	visible = !visible
	get_tree().paused = !get_tree().paused
