extends KinematicBody2D

enum {
	TRACKING,
	PULL_BACK,
	FALLING,
	SHATTERING
}

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D

var state
var velocity = Vector2.ZERO
var trackSpeed = 4000
var trackTimer = 400
var pullBackSpeed = 700
var pullBackTimer = 10
var fallSpeed = 1000
var playerPosition
var target
var timer

func _ready():
	animatedSprite.play("Grow")
	animatedSprite.set_frame(0)
	state = TRACKING
	timer = trackTimer

func _process(delta):
	if state == TRACKING:
		track_player(delta)
	elif state == PULL_BACK:
		pull_back(delta)
	velocity = move_and_slide(velocity)

func update_player_location(pos):
	playerPosition = pos

func track_player(delta):
	timer -= (delta * 100)
	if timer <= 0:
		state = PULL_BACK
		velocity.x = 0
		velocity.y = pullBackSpeed * -1
		timer = pullBackTimer
		animatedSprite.play("Spin")
	else:
		target = playerPosition
		velocity = position.direction_to(target) * trackSpeed
		velocity.y = 0

func pull_back(delta):
	timer -= (delta * 100)
	if timer <= 0:
		fall()

func fall():
	state = FALLING
	velocity.y = fallSpeed

func shatter():
	velocity = Vector2.ZERO
	hitBox.disabled = true
	state = SHATTERING
	animatedSprite.play("Shatter")

func _on_AnimatedSprite_animation_finished():
	if state == TRACKING:
		animatedSprite.play("Static")
	elif state == SHATTERING:
		get_tree().call_group("TheWitch", "cactus_smashed")
		queue_free()

func _on_HitBox_body_entered(_body):
	call_deferred("shatter")
