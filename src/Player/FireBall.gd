extends KinematicBody2D

export var SPEED = 1000

var velocity = Vector2(0, 0)

func _process(delta):
	velocity = move_and_slide(velocity)

func _on_HitBox_area_entered(area):
	print("hit")
	queue_free()
