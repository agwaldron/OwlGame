extends TextureButton

const playMenuPath = "res://src/Environment/Menus/PlayMenu/PlayMenu.tscn"

var selected

func _ready():
	select()

func _process(_delta):
	if selected and Input.is_action_just_pressed("ui_accept"):
		_on_Play_pressed()

func select():
	selected = true
	self.material.set_shader_param("selected", true)

func unselect():
	selected = false
	self.material.set_shader_param("selected", false)

func _on_Play_pressed():
	var _ignore = get_tree().change_scene(playMenuPath)
