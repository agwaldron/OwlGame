extends KinematicBody2D

export var SPEED = 300

enum {
	GROW,
	MOVE,
	DISPERSE
}

onready var animatedSprite = $AnimatedSprite
onready var smallHitBox = $SmallHitBox/CollisionShape2D
onready var mediumHitBox = $MediumHitBox/CollisionShape2D
onready var fullHitBox = $FullHitBox/CollisionShape2D

var state
var velocity = Vector2.ZERO
var sprite_vertical_offset = 150
var sprite_horizontal_offset = 60

func _ready():
	animatedSprite.play("Grow")
	animatedSprite.set_frame(0)
	state = GROW

func _process(_delta):
	velocity = move_and_slide(velocity)

func collision():
	velocity.x = 0
	animatedSprite.play("Disperse")
	animatedSprite.set_frame(0)
	smallHitBox.disabled = true
	mediumHitBox.disabled = true
	fullHitBox.disabled = true
	state = DISPERSE

func _on_AnimatedSprite_frame_changed():
	if state == GROW:
		if animatedSprite.get_frame() == 1:
			smallHitBox.disabled = false
		elif animatedSprite.get_frame() == 3:
			smallHitBox.disabled = true
			mediumHitBox.disabled = false
		elif animatedSprite.get_frame() == 6:
			mediumHitBox.disabled = true
			fullHitBox.disabled = false

func _on_AnimatedSprite_animation_finished():
	if state == GROW:
		animatedSprite.play("Move")
		velocity.x = SPEED * -1
		state = MOVE
	elif state == DISPERSE:
		get_tree().call_group("dude", "start_attack")
		queue_free()

func _on_HitBox_body_entered(_body):
	call_deferred("collision")
