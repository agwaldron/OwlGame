extends KinematicBody2D

enum {
	SUMMON,
	MOVING,
	VANISH
}

onready var animatedSprite = $AnimatedSprite
onready var hitBoxSmallBody = $HitBoxSmallBody/CollisionShape2D
onready var hitBoxFullBody = $HitBoxFullBody/CollisionShape2D
onready var hitBoxSmallWave = $HitBoxSmallWave/CollisionShape2D
onready var hitBoxMediumWave = $HitBoxMediumWave/CollisionShape2D
onready var hitBoxFullWave = $HitBoxFullWave/CollisionShape2D

var state
var velocity = Vector2.ZERO
var speed = 500
var verticalOffset = 310

func _ready():
	state = SUMMON
	animatedSprite.play("Summon")
	animatedSprite.set_frame(0)

func _process(_delta):
	if state == MOVING:
		velocity = move_and_slide(velocity)

func vanish():
	global_position.x += 10
	velocity = Vector2.ZERO
	state = VANISH
	animatedSprite.play("Vanish")
	animatedSprite.set_frame(0)
	hitBoxFullBody.disabled = true
	hitBoxFullWave.disabled = true
	get_tree().call_group("TheWitch", "wine_finished")
	get_tree().call_group("player", "disperse_ice_platform")

func _on_AnimatedSprite_frame_changed():
	if state == SUMMON and animatedSprite.get_frame() == 1:
		hitBoxSmallWave.disabled = false
	elif state == SUMMON and animatedSprite.get_frame() == 3:
		hitBoxSmallWave.disabled = true
		hitBoxMediumWave.disabled = false
		hitBoxSmallBody.disabled = false
	elif state == SUMMON and animatedSprite.get_frame() == 5:
		hitBoxMediumWave.disabled = true
		hitBoxFullWave.disabled = false
		hitBoxSmallBody.disabled = true
		hitBoxFullBody.disabled = false

func _on_AnimatedSprite_animation_finished():
	if state == SUMMON:
		animatedSprite.play("Moving")
		get_tree().call_group("winebottle", "vanish")
		state = MOVING
		velocity.x = speed * -1
	elif state == VANISH:
		queue_free()

func _on_HitBoxFullBody_body_entered(_body):
	call_deferred("vanish")
