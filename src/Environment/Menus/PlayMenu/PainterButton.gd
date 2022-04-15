extends TextureButton

const painterArenaPath = "res://src/Levels/ThePainterArena.tscn"

var selected = false

func _process(_delta):
	if selected and Input.is_action_just_pressed("ui_accept"):
		_on_PainterButton_pressed()

func select():
	selected = true
	self.material.set_shader_param("selected", true)

func unselect():
	selected = false
	self.material.set_shader_param("selected", false)

func _on_PainterButton_pressed():
	var _ignore = get_tree().change_scene(painterArenaPath)
