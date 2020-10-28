extends KinematicBody2D

enum {
	SUMMON,
	POUR
}

onready var animatedSprite = $AnimatedSprite
onready var hitboxsmall = $HitBoxSmall/CollisionShape2D
onready var hitboxfull = $HitBox2Full/CollisionShape2D

var state
var horoffset = 60
var vertoffset = 15

func _ready():
	animatedSprite.play("Summon")
	animatedSprite.set_frame(0)
	state = SUMMON
	hitboxsmall.disabled = false

func _on_AnimatedSprite_frame_changed():
	if state == SUMMON and animatedSprite.get_frame() == 3:
		hitboxsmall.disabled = true
		hitboxfull.disabled = false

func _on_AnimatedSprite_animation_finished():
	if state == SUMMON:
		state = POUR
		animatedSprite.play("Pour")
	elif state == POUR:
		get_tree().call_group("TheWitch", "wineFinished")
		queue_free()
