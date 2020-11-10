extends KinematicBody2D

enum {
	TRACKING,
	PULLBACK,
	FALLING,
	SHATTERING
}

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D

var state
var velocity = Vector2.ZERO
var trackspeed = 4000
var tracktimer = 400
var pullbackspeed = 700
var pullbacktimer = 10
var fallspeed = 1000
var playerpos
var target
var timer

func _ready():
	animatedSprite.play("Grow")
	animatedSprite.set_frame(0)
	state = TRACKING
	timer = tracktimer

func _process(delta):
	if state == TRACKING:
		trackPlayer(delta)
	elif state == PULLBACK:
		pullBack(delta)
	velocity = move_and_slide(velocity)

func updatePlayerLocation(pos):
	playerpos = pos

func trackPlayer(delta):
	timer -= (delta * 100)
	if timer <= 0:
		state = PULLBACK
		velocity.x = 0
		velocity.y = pullbackspeed * -1
		timer = pullbacktimer
		animatedSprite.play("Spin")
	else:
		target = playerpos
		velocity = position.direction_to(target) * trackspeed
		velocity.y = 0

func pullBack(delta):
	timer -= (delta * 100)
	if timer <= 0:
		fall()

func fall():
	state = FALLING
	velocity.y = fallspeed

func shatter():
	velocity = Vector2.ZERO
	hitBox.disabled = true
	state = SHATTERING
	animatedSprite.play("Shatter")

func _on_AnimatedSprite_animation_finished():
	if state == TRACKING:
		animatedSprite.play("Static")
	elif state == SHATTERING:
		get_tree().call_group("TheWitch", "cactusSmashed")
		queue_free()

func _on_HitBox_body_entered(_body):
	call_deferred("shatter")
