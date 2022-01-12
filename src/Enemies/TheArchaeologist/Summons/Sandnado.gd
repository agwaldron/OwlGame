extends KinematicBody2D

export var SPEED = -600

enum {
	SUMMON,
	MOVING,
	BLOWING
}

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D

var spriteHorizontalOffset = 100
var velocity
var state

func _ready():
	state = SUMMON
	animatedSprite.play("Summon")
	animatedSprite.set_frame(0)
	velocity = Vector2.ZERO

func _process(delta):
	velocity and move_and_slide(velocity)

func blow_away():
	animatedSprite.play("BlowAway")
	state = BLOWING
	velocity = Vector2.ZERO
	hitBox.disabled = true

func _on_AnimatedSprite_animation_finished():
	match state:
		SUMMON:
			velocity.x = SPEED
			state = MOVING
			animatedSprite.play("Moving")
		BLOWING:
			queue_free()

func _on_HitBox_body_entered(body):
	get_tree().call_group("archaeologist", "summon_complete")
	call_deferred("blow_away")
