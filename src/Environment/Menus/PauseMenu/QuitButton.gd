extends TextureButton

const mainMenuPath = "res://src/Environment/Menus/MainMenu/MainMenu.tscn"

var selected = false

func _process(_delta):
	if get_tree().paused and selected and Input.is_action_just_pressed("ui_accept"):
		_on_QuitButton_pressed()

func select():
	selected = true
	self.material.set_shader_param("selected", true)

func unselect():
	selected = false
	self.material.set_shader_param("selected", false)

func is_selected():
	return selected

func _on_QuitButton_pressed():
	get_tree().paused = false
	var _ignore = get_tree().change_scene(mainMenuPath)
