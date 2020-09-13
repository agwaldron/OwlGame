extends KinematicBody2D

export var CHANGE_COOLDOWN = 150
export var ATTACK_COOLDOWN = 200

enum {
	BLUE,
	RED,
	YELLOW
}

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var state
var changeTimer
var attackTimer
var attackFlag

func _ready():
	stats.health = 15
	state = RED
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
		RED:
			animatedSprite.play("AttackRed")
		YELLOW:
			animatedSprite.play("AttackYellow")

func change_color():
	match state:
		BLUE:
			animatedSprite.play("ChangeRed")
			state = RED
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
