extends KinematicBody2D

export var SPEED = 150

onready var animatedSprite = $AnimatedSprite
onready var hurtBox = $HurtBox/CollisionShape2D
onready var stats = $EnemyStats

var turning
var vanishing
var facingLeft
var minHeight = 660
var target = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	stats.health = 1
	animatedSprite.play("FlyLeft")
	turning = false
	vanishing = false
	facingLeft = true

func _process(_delta):
	if not vanishing:
		velocity = position.direction_to(target) * SPEED
		if velocity.y > 0 and global_position.y >= minHeight:
			velocity.y = 0
		if position.distance_to(target) > 5:
			velocity = move_and_slide(velocity)
		checkTurn()

func checkTurn():
	if facingLeft and velocity.x > 0:
		turn()
	elif not facingLeft and velocity.x < 0:
		turn()

func turn():
	turning = true
	if facingLeft:
		facingLeft = false
		animatedSprite.play("TurnRight")
	else:
		facingLeft = true
		animatedSprite.play("TurnLeft")

func updatePlayerLocation(pos):
	target = pos

func vanish():
	get_tree().call_group("TheWitch", "beeVanish")
	vanishing = true
	if facingLeft:
		animatedSprite.play("VanishLeft")
	else:
		animatedSprite.play("VanishRight")
	animatedSprite.set_frame(0)
	hurtBox.disabled = true

func _on_AnimatedSprite_animation_finished():
	if turning:
		turning = false
		if velocity.x < 0:
			animatedSprite.play("FlyLeft")
			facingLeft = true
		else:
			animatedSprite.play("FlyRight")
			facingLeft = false
	elif vanishing:
		queue_free()

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	call_deferred("vanish")
