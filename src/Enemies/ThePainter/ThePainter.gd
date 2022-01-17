extends KinematicBody2D

export var CHANGE_DURATION = 100
export var BLUE_ATTACK_DURATION = 160
export var RED_ATTACK_DURATION = 275
export var YELLOW_ATTACK_DURATION = 250

enum {
	BLUE,
	RED,
	YELLOW
}

const PaitBall = preload("res://src/Enemies/ThePainter/Paints/PaintBall.tscn")
const PaintBlob = preload("res://src/Enemies/ThePainter/Paints/PaintBlob.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var state
var attackTimer
var changeTimer
var attackFlag
var attackReady

var hitFlashDuration = 8
var hitFlashTimer = 0
var hitFlashFlag = false

var blueHorizontalSpeed0 = -200
var blueHorizontalSpeed1 = -400
var blueHorizontalSpeed2 = -600
var blueHorizontalSpeed3 = -800
var blueVerticalSpeed0 = -900
var blueVerticalSpeed1 = -1100
var blueVerticalSpeed2 = -1300
var blueVerticalSpeed3 = -1500
var blueGravity = 2500
var blueOffsetX = 50
var blueOffsetY = 75

var redVerticalSpeed = -1500
var redOffsetX = 10
var redOffsetY = 150

var yellowHorizontalSpeed = -600
var yellowVerticalSpeed = -500
var yellowOffsetX = 50
var yellowOffsetY = 75

func _ready():
	stats.health = 20
	state = BLUE
	attackFlag = false
	attackReady = false
	changeTimer = CHANGE_DURATION

func _process(delta):
	if hitFlashFlag:
		hit_flash_countdown(delta)
	if attackFlag:
		attackTimer -= (delta * 100)
		if attackReady and animatedSprite.frame == 3:
			attack()
		if attackTimer <= 0:
			attackFlag = false
			changeTimer = CHANGE_DURATION
			change_color()
	else:
		changeTimer -= (delta * 100)
		if changeTimer <= 0:
			attackFlag = true
			attackReady = true
			play_attack_animation()

func attack():
	attackReady = false
	match state:
		BLUE:
			blue_attack()
		RED:
			red_attack()
		YELLOW:
			yellow_attack()

func blue_attack():
	var paintBall = PaitBall.instance()
	get_parent().add_child(paintBall)
	paintBall.global_position = global_position
	paintBall.global_position.x -= blueOffsetX
	paintBall.global_position.y -= blueOffsetY
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blueHorizontalSpeed0, blueVerticalSpeed0)
	paintBall.gravityAcceleration = blueGravity

	paintBall = PaitBall.instance()
	get_parent().add_child(paintBall)
	paintBall.global_position = global_position
	paintBall.global_position.x -= blueOffsetX
	paintBall.global_position.y -= blueOffsetY
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blueHorizontalSpeed1, blueVerticalSpeed1)
	paintBall.gravityAcceleration = blueGravity

	paintBall = PaitBall.instance()
	get_parent().add_child(paintBall)
	paintBall.global_position = global_position
	paintBall.global_position.x -= blueOffsetX
	paintBall.global_position.y -= blueOffsetY
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blueHorizontalSpeed2, blueVerticalSpeed2)
	paintBall.gravityAcceleration = blueGravity

	paintBall = PaitBall.instance()
	get_parent().add_child(paintBall)
	paintBall.global_position = globalPosition
	paintBall.global_position.x -= blueOffsetX
	paintBall.global_position.y -= blueOffsetY
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blueHorizontalSpeed3, blueVerticalSpeed3)
	paintBall.gravityAcceleration = blueGravity

func red_attack():
	var paintBlob = PaintBlob.instance()
	get_parent().add_child(paintBlob)
	paintBlob.global_position = global_position
	paintBlob.global_position.x -= redOffsetX
	paintBlob.global_position.y -= redOffsetY
	paintBlob.set_color("red")
	paintBlob.velocity = Vector2(0, redVerticalSpeed)

func yellow_attack():
	var paintBlob = PaintBlob.instance()
	get_parent().add_child(paintBlob)
	paintBlob.global_position = global_position
	paintBlob.global_position.x -= yellowOffsetX
	paintBlob.global_position.y -= yellowOffsetY
	paintBlob.set_color("yellow")
	paintBlob.velocity = Vector2(yellowHorizontalSpeed, yellowVerticalSpeed)

func change_color():
	match state:
		BLUE:
			animatedSprite.play("ChangeRed")
			state = RED
			changeTimer = CHANGE_DURATION
		RED:
			animatedSprite.play("ChangeYellow")
			state = YELLOW
			changeTimer = CHANGE_DURATION
		YELLOW:
			animatedSprite.play("ChangeBlue")
			state = BLUE
			changeTimer = CHANGE_DURATION

func play_attack_animation():
	match state:
		BLUE:
			animatedSprite.play("AttackBlue")
			attackTimer = BLUE_ATTACK_DURATION
		RED:
			animatedSprite.play("AttackRed")
			attackTimer = RED_ATTACK_DURATION
		YELLOW:
			animatedSprite.play("AttackYellow")
			attackTimer = YELLOW_ATTACK_DURATION

func play_idle_animation():
	match state:
		BLUE:
			animatedSprite.play("IdleBlue")
		RED:
			animatedSprite.play("IdleRed")
		YELLOW:
			animatedSprite.play("IdleYellow")

func hit_flash_countdown(delta):
	if hitFlashTimer <= 0:
		hitFlashFlag = false
		animatedSprite.material.set_shader_param("white", false)
	else:
		hitFlashTimer -= delta * 100

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			hitFlashTimer = hitFlashDuration
			hitFlashFlag = true
			animatedSprite.material.set_shader_param("white", true)
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()

func _on_AnimatedSprite_animation_finished():
	play_idle_animation()
