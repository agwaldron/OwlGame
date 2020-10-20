extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D

var velocity = Vector2.ZERO
var gravityAcceleration = 0
var maxFallSpeed = 1000
var color
var splat = false

func _process(delta):
	if gravityAcceleration == 0:
		velocity = move_and_slide(velocity)
	else:
		velocity.y += gravityAcceleration * delta
		velocity.y = min(velocity.y, maxFallSpeed)
		velocity = move_and_slide(velocity)

func set_color(col):
	color = col
	match color:
		"blue":
			animatedSprite.play("BlueFlying")
		"red":
			animatedSprite.play("RedFlying")
		"yellow":
			animatedSprite.play("YellowFlying")

func splatter():
	splat = true
	velocity = Vector2.ZERO
	gravityAcceleration = 0
	hitBox.disabled = true
	match color:
		"blue":
			animatedSprite.play("BlueSplatter")
		"red":
			animatedSprite.play("RedSplatter")
		"yellow":
			animatedSprite.play("YellowSplatter")

func _on_HitBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "BlockingSpell":
			call_deferred("splatter")

func _on_HitBox_body_entered(body):
	call_deferred("splatter")

func _on_AnimatedSprite_animation_finished():
	if splat:
		queue_free()
