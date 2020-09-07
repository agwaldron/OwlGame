extends KinematicBody2D

export var SPEED = 600

var velocity = Vector2(0, SPEED)

func _process(delta):
	velocity = move_and_slide(velocity)

func explode():
	queue_free()

func _on_HitBox_body_entered(body):
	explode()
