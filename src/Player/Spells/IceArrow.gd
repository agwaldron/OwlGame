extends KinematicBody2D

export var SPEED = 1000

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D

var shattered
var leftDir
var velocity

func _ready():
	shattered = false
	velocity = Vector2(SPEED, 0)
	leftDir = false
	animatedSprite.play("FlyRight")

func _process(_delta):
	velocity = move_and_slide(velocity)

func shatter():
	shattered = true
	velocity = Vector2.ZERO
	hitBox.disabled = true
	if leftDir:
		animatedSprite.play("ShatterLeft")
	else:
		animatedSprite.play("ShatterRight")
	animatedSprite.set_frame(0)

func _on_HitBox_area_entered(_area):
	call_deferred("shatter")

func _on_HitBox_body_entered(_body):
	call_deferred("shatter")

func _on_AnimatedSprite_animation_finished():
	if shattered:
		queue_free()
