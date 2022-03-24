extends TextureButton

var selected = false

func _ready():
	select()

func _process(_delta):
	if get_tree().paused and selected and Input.is_action_just_pressed("ui_accept"):
		_on_ContinueButton_pressed()

func select():
	selected = true
	self.material.set_shader_param("selected", true)

func unselect():
	selected = false
	self.material.set_shader_param("selected", true)

func _on_ContinueButton_pressed():
	get_tree().call_group("PauseMenu", "pause_unpause")
