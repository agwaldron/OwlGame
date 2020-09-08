extends KinematicBody2D

export var CAST_DURATION = 50

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D
onready var sprite_horizontal_offset = 50
onready var cast_timer = CAST_DURATION

func _ready():
	animatedSprite.set_frame(0)

func _process(delta):
	cast_timer -= (delta * 100)
	if animatedSprite.get_frame() == 3:
		hitBox.disabled = false
	if cast_timer <= 0:
		queue_free()
