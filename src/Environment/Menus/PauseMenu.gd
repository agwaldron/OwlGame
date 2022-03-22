extends MarginContainer

const mainMenuPath = "res://src/Environment/Menus/MainMenu.tscn"

onready var continueButton = $CenterContainer/VBoxContainer/ContinueButton
onready var quitButton = $CenterContainer/VBoxContainer/QuitButton

func _ready():
	visible = false
	continueButton.material.set_shader_param("selected", true)

func _process(_delta):
	if Input.is_action_just_pressed("pause_play"):
		pause_unpause()

func pause_unpause():
	get_tree().paused = !get_tree().paused
	visible = !visible

func _on_ContinueButton_pressed():
	pause_unpause()

func _on_QuitButton_pressed():
	get_tree().paused = false
	var _ignore = get_tree().change_scene(mainMenuPath)
