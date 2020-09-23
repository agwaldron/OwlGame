extends KinematicBody2D

export var SPEED = 800
export var CAST_DURATION = 20

onready var animatedSprite = $AnimatedSprite
onready var hitBox = $HitBox/CollisionShape2D
onready var sprite_vertical_offset = 40
onready var sprite_horizontal_offset = 20

var velocity = Vector2(SPEED, 0)
var col = false

func _process(delta):
	velocity = move_and_slide(velocity)

func explode():
	if velocity.x < 0:
		animatedSprite.play("ExplodeLeft")
		animatedSprite.set_frame(0)
	else:
		animatedSprite.play("ExplodeRight")
		animatedSprite.set_frame(0)

	velocity = Vector2.ZERO
	col = true
	hitBox.disabled = true

func _on_HitBox_area_entered(area):
	call_deferred("explode")

func _on_HitBox_body_entered(body):
	call_deferred("explode")

func _on_AnimatedSprite_animation_finished():
	if col:
		queue_free()
