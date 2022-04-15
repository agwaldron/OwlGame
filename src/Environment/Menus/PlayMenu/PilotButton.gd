extends TextureButton

const pilotArenaPath = "res://src/Levels/ThePilotArena.tscn"

var selected = false

func _process(_delta):
	if selected and Input.is_action_just_pressed("ui_accept"):
		_on_PilotButton_pressed()

func select():
	selected = true
	self.material.set_shader_param("selected", true)

func unselect():
	selected = false
	self.material.set_shader_param("selected", false)

func _on_PilotButton_pressed():
	var _ignore = get_tree().change_scene(pilotArenaPath)
