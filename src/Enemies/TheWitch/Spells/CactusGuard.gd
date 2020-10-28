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
	state = DISPERSE
	animatedSprite.play("Disperse")
	animatedSprite.set_frame(0)

func _on_AnimatedSprite_frame_changed():
	if state == GROW and animatedSprite.get_frame() == 2:
		hitboxsmall.disabled = true
		hitboxmedium.disabled = false
	elif state == GROW and animatedSprite.get_frame() == 5:
		hitboxmedium.disabled = true
		hitboxfull.disabled = false
	elif state == DISPERSE and animatedSprite.get_frame() == 2:
		hitboxfull.disabled = true
		hitboxmedium.disabled = false
	elif state == DISPERSE and animatedSprite.get_frame() == 5:
		hitboxmedium.disabled = true
		hitboxsmall.disabled = false

func _on_AnimatedSprite_animation_finished():
	if state == GROW:
		animatedSprite.play("Static")
		get_tree().call_group("TheWitch", "cactusGuardUp")
		state = STATIC
	elif state == DISPERSE:
		get_tree().call_group("TheWitch", "spellFinished")
		queue_free()
