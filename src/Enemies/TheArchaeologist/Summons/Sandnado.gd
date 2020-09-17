extends KinematicBody2D

export var SPEED = -600

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D

var velocity
var moving

func _ready():
	moving = false
	animatedSprite.play("Summon")
	animatedSprite.set_frame(0)
	velocity = Vector2.ZERO

func _process(delta):
	velocity and move_and_slide(velocity)

func _on_AnimatedSprite_animation_finished():
	if not moving:
		velocity.x = SPEED
		moving = true
		animatedSprite.play("Moving")

func _on_HitBox_body_entered(body):
	queue_free()
