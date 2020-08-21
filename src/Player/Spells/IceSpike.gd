extends KinematicBody2D

export var CAST_DURATION = 50

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D
onready var sprite_horizontal_offset = 50
onready var cast_timer = CAST_DURATION

func _process(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 35:
		hitBox.disabled = false
	if cast_timer <= 0:
		remove_spike()

func remove_spike():
	queue_free()
