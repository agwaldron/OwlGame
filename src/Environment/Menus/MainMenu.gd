extends MarginContainer

const playmenu = "res://src/Environment/Menus/PlayMenu.tscn"

func _on_Play_pressed():
	get_tree().change_scene(playmenu)
