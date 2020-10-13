extends KinematicBody2D

enum {
	TRACKING,
	PULLBACK,
	FLYING
}

onready var animatedSprite = $AnimatedSprite
onready var horHitBox = $HorizontalHitBox/CollisionShape2D
onready var vertHitBox = $VerticalHitBox/CollisionShape2D

var state
var trackspeed = 2000
var pullbackspeed = 700
var flyspeed = 1000
var velocity = Vector2.ZERO
var playerpos
var target
var horoffset = 35
var vertoffset = 35
var hortracktimer = 500
var vertracktimer = 250
var pullbackTimer = 20
var timer
var ishor

func _ready():
	animatedSprite.play("Horizontal")
	animatedSprite.set_frame(0)
	animatedSprite.playing = false
	state = TRACKING
	timer = hortracktimer
	horHitBox.disabled = false
	ishor = true

func _process(delta):
	match state:
		TRACKING:
			tracking(delta)
		PULLBACK:
			pullBack(delta)
	velocity = move_and_slide(velocity)

func isVertical():
	animatedSprite.play("Vertical")
	animatedSprite.set_frame(0)
	animatedSprite.playing = false
	horHitBox.disabled = true
	vertHitBox.disabled = false
	ishor = false
	timer = vertracktimer

func tracking(delta):
	target = playerpos
	timer -= (delta * 100)
	if timer <= 0:
		state = PULLBACK
		animatedSprite.playing = true
		timer = pullbackTimer
		if ishor:
			velocity.x = pullbackspeed
			velocity.y = 0
		else:
			velocity.x = 0
			velocity.y = pullbackspeed * -1
	else:
		target = playerpos
		if ishor:
			target.y -= horoffset
			velocity = position.direction_to(target) * trackspeed
			velocity.x = 0
		else:
			target.x -= vertoffset
			velocity = position.direction_to(target) * trackspeed
			velocity.y = 0

func pullBack(delta):
	timer -= (delta * 100)
	if timer <= 0:
		state = FLYING
		if ishor:
			velocity.x = flyspeed * -1
		else:
			velocity.y = flyspeed

func updatePlayerLocation(pos):
	playerpos = pos

func _on_HitBox_body_entered(body):
	queue_free()
