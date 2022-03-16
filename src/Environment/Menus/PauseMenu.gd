extends MarginContainer

var showMenu = false

func _ready():
	visible = false

func _process(_delta):
	if Input.is_action_just_pressed("pause_play"):
		get_tree().paused = !get_tree().paused
		showMenu = !showMenu
		visible = showMenu

func switch_state():
	get_tree().paused = !get_tree().paused
