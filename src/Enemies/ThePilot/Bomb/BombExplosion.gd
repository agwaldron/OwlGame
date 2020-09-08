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

func _process(delta):
	if animatedSprite.get_frame() == 1 and smallHitBox.disabled:
		smallHitBox.disabled = false
	elif animatedSprite.get_frame() == 2 and mediumHitBox.disabled:
		mediumHitBox.disabled = false
	elif animatedSprite.get_frame() == 3 and largeHitBox.disabled:
		createShockwaves()
		largeHitBox.disabled = false
	elif animatedSprite.get_frame() == 7 and not largeHitBox.disabled:
		get_tree().call_group("Shockwave", "fire")
		largeHitBox.disabled = true
	elif animatedSprite.get_frame() == 8 and not mediumHitBox.disabled:
		mediumHitBox.disabled = true
	elif animatedSprite.get_frame() == 9 and not smallHitBox.disabled:
		smallHitBox.disabled = true

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
