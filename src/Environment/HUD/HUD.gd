extends CanvasLayer

onready var gameOverScreen = $GameOver
onready var heartsDisplay = $MarginContainer/VBoxContainer/HBoxContainer/HeartsDisplay
onready var coolDownDisplay = $MarginContainer/VBoxContainer/CoolDowns

func game_over():
	heartsDisplay.visible = false
	coolDownDisplay.visible = false
	gameOverScreen.fade_in()

func set_max_health(val):
	heartsDisplay.set_max(val)

func set_health(val):
	heartsDisplay.set_health(val)
