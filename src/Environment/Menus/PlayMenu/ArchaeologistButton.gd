extends TextureButton

const archaeologistArenaPath = "res://src/Levels/TheArchaeologistArena.tscn"

var selected = false

func _process(_delta):
	if selected and Input.is_action_just_pressed("ui_accept"):
		_on_ArchaeologistButton_pressed()

func select():
	selected = true
	self.material.set_shader_param("selected", true)

func unselect():
	selected = false
	self.material.set_shader_param("selected", false)

func _on_ArchaeologistButton_pressed():
	var _ignore = get_tree().change_scene(archaeologistArenaPath)
