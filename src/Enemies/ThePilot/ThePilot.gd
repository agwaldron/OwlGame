extends KinematicBody2D

export var SPEED = 600
export var POS_TURN_BACK_POINT = 1500
export var NEG_TURN_BACK_POINT = -300
export var FLY_BY_HEIGHT = 675
export var FLY_BACK_LOW_HEIGHT = 500

enum {
	FLYBY,
	FLYBACKLOW
}

onready var stats = $EnemyStats
onready var animatedSprite = $AnimatedSprite

var state
var velocity = Vector2.ZERO


func _ready():
	print(global_position)
	stats.health = 15
	state = FLYBY
	global_position.x = POS_TURN_BACK_POINT
	global_position.y = FLY_BY_HEIGHT
	velocity.x = SPEED * -1

func _process(delta):
	match state:
		FLYBY:
			flyBy(delta)
		FLYBACKLOW:
			flyBackLow(delta)

func flyBy(delta):
	velocity = move_and_slide(velocity)
	if global_position.x < NEG_TURN_BACK_POINT:
		animatedSprite.play("PlaneFar")
		velocity.x = SPEED
		global_position.y = FLY_BACK_LOW_HEIGHT
		state = FLYBACKLOW

func flyBackLow(delta):
	velocity = move_and_slide(velocity)
	if global_position.x > POS_TURN_BACK_POINT:
		animatedSprite.play("PlaneClose")
		velocity.x = SPEED * -1
		global_position.y = FLY_BY_HEIGHT
		state = FLYBY

func _on_HurtBox_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
