extends MarginContainer

const playMenuPath = "res://src/Environment/Menus/PlayMenu.tscn"

onready var playButton = $CenterContainer/VBoxContainer/Play
onready var controlsButton = $CenterContainer/VBoxContainer/Controls
onready var creditsButton = $CenterContainer/VBoxContainer/Credits

func _ready():
	playButton.material.set_shader_param("selected", true)

func _on_Play_pressed():
	var _ignore = get_tree().change_scene(playMenuPath)
