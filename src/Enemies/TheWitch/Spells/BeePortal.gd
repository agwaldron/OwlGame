extends KinematicBody2D

const Bee = preload("res://src/Enemies/TheWitch/Spells/Bee.tscn")

onready var animatedSprite = $AnimatedSprite

func _ready():
	animatedSprite.set_frame(0)

func _on_AnimatedSprite_frame_changed():
	if animatedSprite.get_frame() == 7:
		var bee = Bee.instance()
		get_parent().add_child(bee)
		bee.global_position = global_position

func _on_AnimatedSprite_animation_finished():
	queue_free()
