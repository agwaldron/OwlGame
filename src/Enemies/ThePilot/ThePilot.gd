extends KinematicBody2D

export var SPEED = 600
export var POS_TURN_BACK_POINT = 1500
export var NEG_TURN_BACK_POINT = -300
export var FLY_BY_HEIGHT = 675
export var BOMB_DROP_HEIGHT = 100
export var FLY_BACK_LOW_HEIGHT = 500
export var FLY_BACK_HIGH_HEIGHT = 200

enum {
	FLYBY,
	BOMBDROP,
	FLYBACKLOW,
	FLYBACKHIGH
}

const Bomb = preload("res://src/Enemies/ThePilot/Bomb/Bomb.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats
onready var hurtBox = $HurtBox/CollisionShape2D

var state
var velocity = Vector2.ZERO
var playerLocation
var bombOneReady
var bombTwoReady
var bombThreeReady
var width

func _ready():
	stats.health = 15
	state = FLYBY
	animatedSprite.play("PlaneClose")
	global_position.x = POS_TURN_BACK_POINT
	global_position.y = FLY_BY_HEIGHT
	velocity.x = SPEED * -1
	bombOneReady = false
	bombTwoReady = false
	bombThreeReady = false
	width = get_viewport().size.x

func _process(delta):
	match state:
		FLYBY:
			flyBy(delta)
		BOMBDROP:
			bombDrop(delta)
		FLYBACKLOW:
			flyBackLow(delta)
		FLYBACKHIGH:
			flyBackHigh(delta)

func flyBy(delta):
	velocity = move_and_slide(velocity)
	if global_position.x < NEG_TURN_BACK_POINT:
		animatedSprite.play("PlaneFar")
		velocity.x = SPEED
		global_position.y = FLY_BACK_HIGH_HEIGHT
		state = FLYBACKHIGH
		hurtBox.disabled = true

func bombDrop(delta):
	velocity = move_and_slide(velocity)
	#if bombReady:
		#checkForPlayer()
	checkForDropSite()
	if global_position.x < NEG_TURN_BACK_POINT:
		animatedSprite.play("PlaneFar")
		velocity.x = SPEED
		global_position.y = FLY_BACK_LOW_HEIGHT
		state = FLYBACKLOW
		hurtBox.disabled = true

func flyBackLow(delta):
	velocity = move_and_slide(velocity)
	if global_position.x > POS_TURN_BACK_POINT:
		animatedSprite.play("PlaneClose")
		velocity.x = SPEED * -1
		global_position.y = FLY_BY_HEIGHT
		state = FLYBY
		hurtBox.disabled = false

func flyBackHigh(delta):
	velocity = move_and_slide(velocity)
	if global_position.x > POS_TURN_BACK_POINT:
		animatedSprite.play("PlaneClose")
		velocity.x = SPEED * -1
		global_position.y = BOMB_DROP_HEIGHT
		state = BOMBDROP
		hurtBox.disabled = false
		bombOneReady = true
		bombTwoReady = true
		bombThreeReady = true

func updatePlayerLocation(loc):
	playerLocation = loc

func checkForPlayer():
	if abs(playerLocation[0] - global_position.x) < 10:
		var bomb = Bomb.instance()
		get_parent().add_child(bomb)
		bomb.global_position = global_position
		#bombReady = false

func checkForDropSite():
	if abs(global_position.x - width*3/4) < 10 and bombOneReady:
		var bomb = Bomb.instance()
		get_parent().add_child(bomb)
		bomb.global_position = global_position
		bombOneReady = false

	if abs(global_position.x - width/2) < 10 and bombTwoReady:
		var bomb = Bomb.instance()
		get_parent().add_child(bomb)
		bomb.global_position = global_position
		bombTwoReady = false

	if abs(global_position.x - width/4) < 10 and bombThreeReady:
		var bomb = Bomb.instance()
		get_parent().add_child(bomb)
		bomb.global_position = global_position
		bombThreeReady = false

func _on_HurtBox_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
