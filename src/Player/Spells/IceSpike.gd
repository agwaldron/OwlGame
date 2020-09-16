extends KinematicBody2D

export var CAST_DURATION = 50

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D
onready var sprite_horizontal_offset = 50
onready var cast_timer = CAST_DURATION

var shtr = false
var left = true

func _ready():
	animatedSprite.set_frame(0)

func _process(delta):
	cast_timer -= (delta * 100)
	if cast_timer <= 0:
		shatter()

func spell_interrupt():
	queue_free()

func shatter():
	shtr = true
	hitBox.disabled = true
	if left:
		animatedSprite.play("ShatterLeft")
	else:
		animatedSprite.play("ShatterRight")

func _on_AnimatedSprite_animation_finished():
	if shtr:
		queue_free()

func _on_AnimatedSprite_frame_changed():
	if animatedSprite.get_frame() == 3 and not shtr:
		get_tree().call_group("camera", "ice_spike")
		hitBox.disabled = false
