extends KinematicBody2D

export var CAST_DURATION = 30

onready var sprite = $Sprite
onready var sprite_horizontal_offset = 50
onready var cast_timer = CAST_DURATION

func _process(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		remove_spike()

func remove_spike():
	queue_free()
