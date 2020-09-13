extends KinematicBody2D

export var CHANGE_COOLDOWN = 150
export var ATTACK_COOLDOWN = 200

enum {
	BLUE,
	RED,
	YELLOW
}

const PaitBall = preload("res://src/Enemies/ThePainter/Paints/PaintBall.tscn")
const PaitBlob = preload("res://src/Enemies/ThePainter/Paints/PaintBlob.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var state
var changeTimer
var attackTimer
var attackFlag

var blue_horizontal_speed0 = -200
var blue_horizontal_speed1 = -400
var blue_horizontal_speed2 = -600
var blue_horizontal_speed3 = -800
var blue_vertical_speed0 = -900
var blue_vertical_speed1 = -1100
var blue_vertical_speed2 = -1300
var blue_vertical_speed3 = -1500
var blue_offset_x = 50
var blue_offset_y = 50
var red_offset_x = 50
var red_offset_y = 50
var yellow_offset_x = 50
var yellow_offset_y = 50

func _ready():
	stats.health = 15
	state = BLUE
	attackFlag = true
	changeTimer = CHANGE_COOLDOWN
	attackTimer = ATTACK_COOLDOWN

func _process(delta):
	if attackFlag:
		attackTimer -= (delta * 100)
		if attackTimer <= 0:
			attack()
			changeTimer = CHANGE_COOLDOWN
			attackFlag = false
	else:
		changeTimer -= (delta * 100)
		if changeTimer <= 0:
			change_color()
			attackTimer = ATTACK_COOLDOWN
			attackFlag = true

func attack():
	match state:
		BLUE:
			animatedSprite.play("AttackBlue")
			blue_attack()
		RED:
			animatedSprite.play("AttackRed")
			red_attack()
		YELLOW:
			animatedSprite.play("AttackYellow")
			yellow_attack()

func blue_attack():
	var paintBall = PaitBall.instance()
	get_parent().add_child(paintBall)
	paintBall.global_position = global_position
	paintBall.global_position.x -= blue_offset_x
	paintBall.global_position.y -= blue_offset_y
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blue_horizontal_speed0, blue_vertical_speed0)

	paintBall = PaitBall.instance()
	get_parent().add_child(paintBall)
	paintBall.global_position = global_position
	paintBall.global_position.x -= blue_offset_x
	paintBall.global_position.y -= blue_offset_y
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blue_horizontal_speed1, blue_vertical_speed1)

	paintBall = PaitBall.instance()
	get_parent().add_child(paintBall)
	paintBall.global_position = global_position
	paintBall.global_position.x -= blue_offset_x
	paintBall.global_position.y -= blue_offset_y
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blue_horizontal_speed2, blue_vertical_speed2)

	paintBall = PaitBall.instance()
	get_parent().add_child(paintBall)
	paintBall.global_position = global_position
	paintBall.global_position.x -= blue_offset_x
	paintBall.global_position.y -= blue_offset_y
	paintBall.set_color("blue")
	paintBall.velocity = Vector2(blue_horizontal_speed3, blue_vertical_speed3)

func red_attack():
	pass

func yellow_attack():
	pass

func change_color():
	match state:
		BLUE:
			animatedSprite.play("ChangeRed")
			state = BLUE
		RED:
			animatedSprite.play("ChangeYellow")
			state = YELLOW
		YELLOW:
			animatedSprite.play("ChangeBlue")
			state = BLUE

func play_idle_animation():
	match state:
		BLUE:
			animatedSprite.play("IdleBlue")
		RED:
			animatedSprite.play("IdleRed")
		YELLOW:
			animatedSprite.play("IdleYellow")

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()


func _on_AnimatedSprite_animation_finished():
	play_idle_animation()
