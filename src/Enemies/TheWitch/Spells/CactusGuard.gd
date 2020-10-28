extends KinematicBody2D

enum {
	GROW,
	STATIC,
	DISPERSE
}

onready var animatedSprite = $AnimatedSprite
onready var hitboxsmall = $HitBoxSmall/CollisionShape2D
onready var hitboxmedium = $HitBoxMedium/CollisionShape2D
onready var hitboxfull = $HitBoxFull/CollisionShape2D

var state
var horoffset = 120
var vertoffset = 5

func _ready():
	animatedSprite.play("Grow")
	animatedSprite.set_frame(0)
	hitboxsmall.disabled = false
	state = GROW

func disperse():
	queue_free()

func _on_AnimatedSprite_frame_changed():
	if animatedSprite.get_frame() == 2:
		hitboxsmall.disabled = true
		hitboxmedium.disabled = false
	elif animatedSprite.get_frame() == 5:
		hitboxmedium.disabled = true
		hitboxfull.disabled = false

func _on_AnimatedSprite_animation_finished():
	if state == GROW:
		animatedSprite.play("Static")
		get_tree().call_group("TheWitch", "cactusGuardUp")
		state = STATIC
