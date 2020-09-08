extends KinematicBody2D

export var SPEED = 600

const BombExplsion = preload("res://src/Enemies/ThePilot/Bomb/BombExplosion.tscn")

var velocity = Vector2(0, SPEED)

func _process(delta):
	velocity = move_and_slide(velocity)

func explode():
	var bombExplosion = BombExplsion.instance()
	get_parent().add_child(bombExplosion)
	bombExplosion.global_position = global_position
	queue_free()

func _on_HitBox_body_entered(body):
	explode()
