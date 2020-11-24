extends CanvasLayer

onready var gameoverscreen = $GameOver
onready var heartsdisplay = $MarginContainer/VBoxContainer/HBoxContainer/HeartsDisplay
onready var cooldowndisplay = $MarginContainer/VBoxContainer/CoolDowns

func gameOver():
	heartsdisplay.visible = false
	cooldowndisplay.visible = false
	gameoverscreen.fadeIn()

func setMaxHealth(val):
	heartsdisplay.setMax(val)

func setHealth(val):
	heartsdisplay.setHealth(val)
