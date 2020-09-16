extends KinematicBody2D

export var SHUFFLE_SPEED = 100

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var velocity = Vector2.ZERO
var movingLeft
var turnAroundLeft = 200
var turnAroundRight = 1400

func _ready():
	stats.health = 2
	movingLeft = true
	velocity.x = -SHUFFLE_SPEED

func _process(delta):
	if global_position.x < turnAroundLeft or global_position.x > turnAroundRight:
		turn_around()
	velocity = move_and_slide(velocity)

func turn_around():
	if movingLeft:
		animatedSprite.play("ShuffleRight")
		velocity.x = SHUFFLE_SPEED
		movingLeft = false
	else:
		animatedSprite.play("ShuffleLeft")
		velocity.x = -SHUFFLE_SPEED
		movingLeft = true

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
