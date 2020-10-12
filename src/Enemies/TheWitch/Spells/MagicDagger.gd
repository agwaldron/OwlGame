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
var trackTimer = 500
var pullbackTimer = 10
var timer

func _ready():
	animatedSprite.play("Horizontal")
	animatedSprite.set_frame(0)
	animatedSprite.playing = false
	state = TRACKING
	timer = trackTimer
	horHitBox.disabled = false

func _process(delta):
	match state:
		TRACKING:
			target = playerpos
			target.y -= horoffset
			velocity = position.direction_to(target) * trackspeed
			velocity.x = 0
			timer -= (delta * 100)
			if timer <= 0:
				state = PULLBACK
				velocity.y = 0
				velocity.x = pullbackspeed
				timer = pullbackTimer
				animatedSprite.playing = true
		PULLBACK:
			timer -= (delta * 100)
			if timer <= 0:
				state = FLYING
				velocity.x = flyspeed * -1
	velocity = move_and_slide(velocity)

func isVertical():
	pass

func updatePlayerLocation(pos):
	playerpos = pos

func _on_HitBox_body_entered(body):
	queue_free()
