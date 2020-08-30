extends KinematicBody2D

export var CAST_DURATION = 125

onready var animatedSprite = $AnimatedSprite
onready var sprite_horizontal_offset = 75
onready var cast_timer = CAST_DURATION

func _process(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		remove_lightening()

func remove_lightening():
	queue_free()
