extends MarginContainer

const playMenuPath = "res://src/Environment/Menus/PlayMenu.tscn"

func _on_Play_pressed():
	var _ignore = get_tree().change_scene(playMenuPath)
