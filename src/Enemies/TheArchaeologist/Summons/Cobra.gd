extends KinematicBody2D

enum {
	SUMMON,
	MOVING,
	VANISH
}

onready var animatedSprite = $AnimatedSprite
onready var movingNeckHitBox = $MovingNeckHitBox/CollisionShape2D
onready var movingBodyHitBox = $MovingBodyHitBox/CollisionShape2D

var state
var velocity = Vector2.ZERO
var speed = 600

func _ready():
	animatedSprite.play("Summon")
	animatedSprite.set_frame(0)
	state = SUMMON

func _process(delta):
	if state == MOVING:
		velocity = move_and_slide(velocity)

func startMoving():
	state = MOVING
	velocity.x = speed * -1
	movingNeckHitBox.disabled = false
	movingBodyHitBox.disabled = false

func vanish():
	velocity = Vector2.ZERO
	state = VANISH
	animatedSprite.play("Vanish")
	animatedSprite.set_frame(0)

func _on_AnimatedSprite_animation_finished():
	if state == SUMMON:
		call_deferred("startMoving")
	elif state == VANISH:
		queue_free()
