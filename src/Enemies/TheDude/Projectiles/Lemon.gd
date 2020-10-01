extends KinematicBody2D

export var HORIZONTAL_SPEED = -400

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D
onready var sprite_horizontal_offset = 60
onready var sprite_vertical_offset = 130

var bounces = 0
var bouncespeed1 = 400
var bouncespeed2 = 325
var bouncespeed3 = 250
var gravity = 600
var maxFallSpeed = 1000
var velocity = Vector2.ZERO
var explode = false

func _ready():
	animatedSprite.play("Turn")

func _process(delta):
	if not explode:
		velocity.y += (gravity * delta)
		velocity.y = min(velocity.y, maxFallSpeed)
		velocity = move_and_slide(velocity, Vector2.UP)

func explode():
	animatedSprite.play("Explode")
	hitBox.disabled = true
	explode = true

func bounce_floor():
	bounces += 1
	if bounces == 1:
		velocity.y = -bouncespeed1
	elif bounces == 2:
		velocity.y = -bouncespeed2
	elif bounces == 3:
		velocity.y = -bouncespeed3
	else:
		call_deferred("explode")

func bounce_wall():
	velocity.x = velocity.x * -1

func _on_AnimatedSprite_animation_finished():
	if explode:
		get_tree().call_group("dude", "start_attack")
		queue_free()

func _on_HitBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "BlockingSpell":
			call_deferred("explode")

func _on_HitBox_body_entered(body):
	var areaGroups = body.get_groups()
	for x in areaGroups:
		if x == "wall":
			bounce_wall()
		else:
			bounce_floor()
