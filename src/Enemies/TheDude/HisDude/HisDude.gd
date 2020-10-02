extends KinematicBody2D

export var SPEED = 500

enum {
	IDLEMIN,
	IDLEMAX,
	LEAPOFFMIN,
	LEAPOFFMAX,
	LEAPINGLEFT,
	LEAPINGRIGHT,
	LANDMIN,
	LANDMAX
}

onready var animatedSprite = $AnimatedSprite
onready var standingHitBox = $StandingHurtBox/CollisionShape2D
onready var leapingHitBox = $LeapingHurtBox/CollisionShape2D
onready var stats = $EnemyStats

var minLeftPos = 250
var maxLeftPos = 975
var leapCoolDown = 250
var leapTimer = 0
var state
var velocity = Vector2.ZERO

func _ready():
	stats.health = 15
	state = IDLEMIN
	animatedSprite.play("IdleRight")
	leapTimer = leapCoolDown
	standingHitBox.disabled = false
	global_position.x = minLeftPos

func _process(delta):
	if state == IDLEMIN or state == IDLEMAX:
		leapTimer -= (delta * 100)
		if leapTimer <= 0:
			leap()
	elif state == LEAPINGLEFT or state == LEAPINGRIGHT:
		velocity = move_and_slide(velocity)
		if global_position.x <= minLeftPos or global_position.x >= maxLeftPos:
			land()

func leap():
	if state == IDLEMIN:
		animatedSprite.play("LeapOffRight")
		state = LEAPOFFMIN
	else:
		animatedSprite.play("LeapOffLeft")
		state = LEAPOFFMAX
	animatedSprite.set_frame(0)

func land():
	if state == LEAPINGLEFT:
		animatedSprite.play("IdleRight")
		state = IDLEMIN
	else:
		animatedSprite.play("IdleLeft")
		state = IDLEMAX
	leapingHitBox.disabled = true
	standingHitBox.disabled = false
	velocity.x = 0
	leapTimer = leapCoolDown

func _on_AnimatedSprite_animation_finished():
	if state == LEAPOFFMIN:
		animatedSprite.play("LeapRight")
		standingHitBox.disabled = true
		leapingHitBox.disabled = false
		velocity.x = SPEED
		state = LEAPINGRIGHT
	elif state == LEAPOFFMAX:
		animatedSprite.play("LeapLeft")
		standingHitBox.disabled = true
		leapingHitBox.disabled = false
		velocity.x = SPEED * -1
		state = LEAPINGLEFT
	elif state == LANDMIN:
		pass
	elif state == LANDMAX:
		pass

func _on_HurtBox_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
