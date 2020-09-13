extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite

var velocity = Vector2.ZERO
var gravityAcceleration = 2500
var maxFallSpeed = 1500

func _process(delta):
	velocity.y += gravityAcceleration * delta
	velocity.y = min(velocity.y, maxFallSpeed)
	velocity = move_and_slide(velocity)

func set_color(col):
	match col:
		"blue":
			animatedSprite.play("Blue")
		"red":
			animatedSprite.play("Red")
		"yellow":
			animatedSprite.play("Yellow")

func _on_HitBox_body_entered(body):
	queue_free()
