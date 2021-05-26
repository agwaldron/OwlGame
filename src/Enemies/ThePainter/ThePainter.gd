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

var hitflashduration = 8
var hitflashtimer = 0
var hitflashflag = false

var blue_horizontal_speed0 = -200
var blue_horizontal_speed1 = -400
var blue_horizontal_speed2 = -600
var blue_horizontal_speed3 = -800
var blue_vertical_speed0 = -900
var blue_vertical_speed1 = -1100
var blue_vertical_speed2 = -1300
var blue_vertical_speed3 = -1500
var blue_gravity = 2500
var blue_offset_x = 50
var blue_offset_y = 75

var red_vertical_speed = -1500
var red_offset_x = 10
var red_offset_y = 150

var yellow_horizontal_speed = -600
var yellow_vertical_speed = -500
var yellow_offset_x = 50
var yellow_offset_y = 75

func _ready():
	stats.health = 20
	state = BLUE
	attackFlag = false
	attackReady = false
	changeTimer = CHANGE_DURATION

func _process(delta):
	if hitflashflag:
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
	paintBall.global_position.x -= blue_offset_x
	paintBall.global_position.y -= blue_offset_y
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blue_horizontal_speed0, blue_vertical_speed0)
	paintBall.gravityAcceleration = blue_gravity

	paintBall = PaitBall.instance()
	get_parent().add_child(paintBall)
	paintBall.global_position = global_position
	paintBall.global_position.x -= blue_offset_x
	paintBall.global_position.y -= blue_offset_y
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blue_horizontal_speed1, blue_vertical_speed1)
	paintBall.gravityAcceleration = blue_gravity

	paintBall = PaitBall.instance()
	get_parent().add_child(paintBall)
	paintBall.global_position = global_position
	paintBall.global_position.x -= blue_offset_x
	paintBall.global_position.y -= blue_offset_y
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blue_horizontal_speed2, blue_vertical_speed2)
	paintBall.gravityAcceleration = blue_gravity

	paintBall = PaitBall.instance()
	get_parent().add_child(paintBall)
	paintBall.global_position = global_position
	paintBall.global_position.x -= blue_offset_x
	paintBall.global_position.y -= blue_offset_y
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blue_horizontal_speed3, blue_vertical_speed3)
	paintBall.gravityAcceleration = blue_gravity

func red_attack():
	var paintBlob = PaintBlob.instance()
	get_parent().add_child(paintBlob)
	paintBlob.global_position = global_position
	paintBlob.global_position.x -= red_offset_x
	paintBlob.global_position.y -= red_offset_y
	paintBlob.set_color("red")
	paintBlob.velocity = Vector2(0, red_vertical_speed)

func yellow_attack():
	var paintBlob = PaintBlob.instance()
	get_parent().add_child(paintBlob)
	paintBlob.global_position = global_position
	paintBlob.global_position.x -= yellow_offset_x
	paintBlob.global_position.y -= yellow_offset_y
	paintBlob.set_color("yellow")
	paintBlob.velocity = Vector2(yellow_horizontal_speed, yellow_vertical_speed)

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
	if hitflashtimer <= 0:
		hitflashflag = false
		animatedSprite.material.set_shader_param("white", false)
	else:
		hitflashtimer -= delta * 100

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			hitflashtimer = hitflashduration
			hitflashflag = true
			animatedSprite.material.set_shader_param("white", true)
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()

func _on_AnimatedSprite_animation_finished():
	play_idle_animation()
