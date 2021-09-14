extends Node2D

const Mummy = preload("res://src/Enemies/TheArchaeologist/Summons/Mummy.tscn")

onready var animatedSprite = $AnimatedSprite

func _ready():
	animatedSprite.play("SummonLeft")
	animatedSprite.set_frame(0)

func _on_AnimatedSprite_animation_finished():
	var mummy = Mummy.instance()
	mummy.global_position = global_position
	get_parent().add_child(mummy)
	get_tree().call_group("archaeologist", "summon_complete")
	queue_free()
