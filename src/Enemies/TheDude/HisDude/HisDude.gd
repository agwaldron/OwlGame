extends KinematicBody2D

export var SPEED = 500

enum {
	IDLE_MIN,
	IDLE_MAX,
	LEAP_OFF_MIN,
	LEAP_OFF_MAX,
	LEAPING_LEFT,
	LEAPING_RIGHT,
	LAND_MIN,
	LAND_MAX
}

onready var animatedSprite = $AnimatedSprite
onready var standingHitBox = $StandingHurtBox/CollisionShape2D
onready var leapingHitBox = $LeapingHurtBox/CollisionShape2D
onready var stats = $EnemyStats

var minLeftPos = 125
var maxLeftPos = 975
var leapCoolDown = 200
var leapTimer = 0
var state
var velocity = Vector2.ZERO

var hitflashduration = 8
var hitflashtimer = 0
var hitflashflag = false

func _ready():
	stats.health = 15
	state = IDLE_MIN
	animatedSprite.play("IdleRight")
	leapTimer = leapCoolDown
	standingHitBox.disabled = false
	global_position.x = minLeftPos

func _process(delta):
	if hitflashflag:
		hit_flash_countdown(delta)
	if state == IDLE_MIN or state == IDLE_MAX:
		leapTimer -= (delta * 100)
		if leapTimer <= 0:
			leap()
	elif state == LEAPING_LEFT or state == LEAPING_RIGHT:
		velocity = move_and_slide(velocity)
		if global_position.x <= minLeftPos or global_position.x >= maxLeftPos:
			land()

func leap():
	if state == IDLE_MIN:
		animatedSprite.play("LeapOffRight")
		state = LEAP_OFF_MIN
	else:
		animatedSprite.play("LeapOffLeft")
		state = LEAP_OFF_MAX
	animatedSprite.set_frame(0)

func land():
	if state == LEAPING_LEFT:
		animatedSprite.play("LandLeft")
		state = LAND_MIN
	else:
		animatedSprite.play("LandRight")
		state = LAND_MAX
	leapingHitBox.disabled = true
	standingHitBox.disabled = false
	velocity.x = 0

func hit_flash_countdown(delta):
	if hitflashtimer <= 0:
		hitflashflag = false
		animatedSprite.material.set_shader_param("white", false)
	else:
		hitflashtimer -= delta * 100

func _on_AnimatedSprite_animation_finished():
	if state == LEAP_OFF_MIN:
		animatedSprite.play("LeapingRight")
		standingHitBox.disabled = true
		leapingHitBox.disabled = false
		velocity.x = SPEED
		state = LEAPING_RIGHT
	elif state == LEAP_OFF_MAX:
		animatedSprite.play("LeapingLeft")
		standingHitBox.disabled = true
		leapingHitBox.disabled = false
		velocity.x = SPEED * -1
		state = LEAPING_LEFT
	elif state == LAND_MIN:
		animatedSprite.play("IdleRight")
		state = IDLE_MIN
		leapTimer = leapCoolDown
	elif state == LAND_MAX:
		animatedSprite.play("IdleLeft")
		state = IDLE_MAX
		leapTimer = leapCoolDown

func _on_HurtBox_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			hitflashtimer = hitflashduration
			hitflashflag = true
			animatedSprite.material.set_shader_param("white", true)
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	get_tree().call_group("dude", "enrage_flag")
	queue_free()
