extends KinematicBody2D

export var CAST_DURATION = 50

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D
onready var spriteHorizontalOffset = 50
onready var castTimer = CAST_DURATION

var shattering = false
var left = true

func _ready():
	animatedSprite.set_frame(0)

func _process(delta):
	castTimer -= (delta * 100)
	if castTimer <= 0:
		shatter()

func spell_interrupt():
	queue_free()

func shatter():
	shattering = true
	hitBox.disabled = true
	if left:
		animatedSprite.play("ShatterLeft")
	else:
		animatedSprite.play("ShatterRight")

func _on_AnimatedSprite_animation_finished():
	if shattering:
		queue_free()

func _on_AnimatedSprite_frame_changed():
	if animatedSprite.get_frame() == 3 and not shattering:
		get_tree().call_group("camera", "ice_spike")
		hitBox.disabled = false
