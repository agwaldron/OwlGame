extends KinematicBody2D

const IceArrow = preload("res://src/Player/Spells/IceArrow.tscn")

onready var animatedSprite = $AnimatedSprite

var sprite_horizontal_offset = 60
var sprite_vertical_offset = 45
var leftDir

func face_left():
	leftDir = true
	animatedSprite.play("CastLeft")
	animatedSprite.set_frame(0)

func face_right():
	leftDir = false
	animatedSprite.play("CastRight")
	animatedSprite.set_frame(0)

func spell_interrupt():
	queue_free()

func _on_AnimatedSprite_frame_changed():
	if animatedSprite.get_frame() == 6:
		var iceArrow = IceArrow.instance()
		get_parent().add_child(iceArrow)
		iceArrow.global_position = global_position
		if leftDir:
			iceArrow.velocity.x = iceArrow.SPEED * -1
		get_tree().call_group("player", "ice_arrow_released")

func _on_AnimatedSprite_animation_finished():
	queue_free()
