extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite

var velocity = Vector2.ZERO
var gravityAcceleration = 0
var maxFallSpeed = 1000

func _process(delta):
	if gravityAcceleration == 0:
		velocity = move_and_slide(velocity)
	else:
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

func _on_HitBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "BlockingSpell":
			queue_free()

func _on_HitBox_body_entered(body):
	queue_free()
