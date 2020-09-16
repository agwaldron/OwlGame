extends KinematicBody2D

const Shockwave = preload("res://src/Enemies/ThePilot/Bomb/Shockwave.tscn")

onready var animatedSprite = $AnimatedSprite
onready var smallHitBox = $SmallHitBox/CollisionShape2D
onready var mediumHitBox = $MediumHitBox/CollisionShape2D
onready var largeHitBox = $LargeHitBox/CollisionShape2D

var leftShockwave
var rightShockwave

func _ready():
	animatedSprite.play("Explode")
	animatedSprite.set_frame(0)

func createShockwaves():
	leftShockwave = Shockwave.instance()
	get_parent().add_child(leftShockwave)
	leftShockwave.global_position = global_position
	leftShockwave.global_position.x -= leftShockwave.sprite_horizontal_offset
	leftShockwave.global_position.y -= leftShockwave.sprite_vertical_offset
	leftShockwave.SPEED = leftShockwave.SPEED * -1
	leftShockwave.sprite.flip_h = true

	rightShockwave = Shockwave.instance()
	get_parent().add_child(rightShockwave)
	rightShockwave.global_position = global_position
	rightShockwave.global_position.x += rightShockwave.sprite_horizontal_offset
	rightShockwave.global_position.y -= rightShockwave.sprite_vertical_offset

func _on_AnimatedSprite_animation_finished():
	queue_free()

func _on_AnimatedSprite_frame_changed():
	if animatedSprite.get_frame() == 1:
		smallHitBox.disabled = false
	elif animatedSprite.get_frame() == 2:
		mediumHitBox.disabled = false
	elif animatedSprite.get_frame() == 3:
		createShockwaves()
		largeHitBox.disabled = false
	elif animatedSprite.get_frame() == 7:
		get_tree().call_group("Shockwave", "fire")
		largeHitBox.disabled = true
	elif animatedSprite.get_frame() == 8:
		mediumHitBox.disabled = true
	elif animatedSprite.get_frame() == 9:
		smallHitBox.disabled = true
