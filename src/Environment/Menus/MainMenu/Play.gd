extends TextureButton

const playMenuPath = "res://src/Environment/Menus/PlayMenu/PlayMenu.tscn"

func _ready():
	self.material.set_shader_param("selected", true)

func _on_Play_pressed():
	var _ignore = get_tree().change_scene(playMenuPath)
