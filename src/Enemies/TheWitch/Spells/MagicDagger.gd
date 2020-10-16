extends KinematicBody2D

enum {
	TRACKING,
	PULLBACK,
	FLYING,
	VANISH
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
var hortracktimer = 400
var vertracktimer = 200
var pullbackTimer = 20
var timer
var ishor
var spawning

func _ready():
	animatedSprite.play("SpawnHorizontal")
	animatedSprite.set_frame(0)
	state = TRACKING
	timer = hortracktimer
	horHitBox.disabled = false
	ishor = true
	spawning = true

func _process(delta):
	match state:
		TRACKING:
			tracking(delta)
		PULLBACK:
			pullBack(delta)
	velocity = move_and_slide(velocity)

func isVertical():
	animatedSprite.play("SpawnVertical")
	animatedSprite.set_frame(0)
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

func vanish():
	if ishor:
		animatedSprite.play("VanishHorizontal")
		horHitBox.disabled = true
		get_tree().call_group("TheWitch", "spellFinished")
	else:
		animatedSprite.play("VanishVertical")
		vertHitBox.disabled = true
	animatedSprite.set_frame(0)
	state = VANISH
	velocity = Vector2.ZERO

func _on_AnimatedSprite_animation_finished():
	if spawning:
		if ishor:
			animatedSprite.play("Horizontal")
		else:
			animatedSprite.play("Vertical")
		animatedSprite.set_frame(0)
		animatedSprite.playing = false
		spawning = false
	elif state == VANISH:
		queue_free()

func _on_HitBox_body_entered(body):
	call_deferred("vanish")
