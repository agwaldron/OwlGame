extends KinematicBody2D

enum {
	GROW,
	STATIC,
	DISPERSE
}

onready var animatedSprite = $AnimatedSprite
onready var hitBoxSmall = $HitBoxSmall/CollisionShape2D
onready var hitBoxMedium = $HitBoxMedium/CollisionShape2D
onready var hitBoxFull = $HitBoxFull/CollisionShape2D

var state
var horizontalOffset = 120
var verticalOffset = 5

func _ready():
	animatedSprite.play("Grow")
	animatedSprite.set_frame(0)
	hitBoxSmall.disabled = false
	state = GROW

func disperse():
	state = DISPERSE
	animatedSprite.play("Disperse")
	animatedSprite.set_frame(0)

func _on_AnimatedSprite_frame_changed():
	if state == GROW and animatedSprite.get_frame() == 2:
		hitBoxSmall.disabled = true
		hitBoxMedium.disabled = false
	elif state == GROW and animatedSprite.get_frame() == 5:
		hitBoxMedium.disabled = true
		hitBoxFull.disabled = false
	elif state == DISPERSE and animatedSprite.get_frame() == 2:
		hitBoxFull.disabled = true
		hitBoxMedium.disabled = false
	elif state == DISPERSE and animatedSprite.get_frame() == 5:
		hitBoxMedium.disabled = true
		hitBoxSmall.disabled = false

func _on_AnimatedSprite_animation_finished():
	if state == GROW:
		animatedSprite.play("Static")
		get_tree().call_group("TheWitch", "cactus_guard_up")
		state = STATIC
	elif state == DISPERSE:
		get_tree().call_group("TheWitch", "cactus_finished")
		queue_free()
