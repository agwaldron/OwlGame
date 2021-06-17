extends KinematicBody2D

enum{
	LEFTNOBEER,
	LEFTBEER,
	RIGHTNOBEER,
	RIGHTBEER
}

onready var animatedSprite = $AnimatedSprite
onready var hurtBox = $HurtBox/CollisionShape2D
onready var stats = $EnemyStats

var state
var speed = 275
var velocity = Vector2.ZERO
var movingleft

func _ready():
	state = LEFTBEER
	animatedSprite.play("MoveLeftBeer")
	movingleft = true
	velocity = Vector2(speed * -1, 0)

func _process(delta):
	if is_on_wall():
		turn_around()
	velocity = move_and_slide(velocity)

func turn_around():
	if movingleft:
		animatedSprite.play("MoveRightBeer")
		movingleft = false
		velocity = Vector2(speed, 0)
	else:
		animatedSprite.play("MoveLeftBeer")
		movingleft = true
		velocity = Vector2(speed * -1, 0)
