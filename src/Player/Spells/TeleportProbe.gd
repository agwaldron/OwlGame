extends KinematicBody2D

var speed = 600
var velocity = Vector2(speed, 0)
var probeduration = 25
var probetimer = 0

func _process(delta):
	velocity = move_and_slide(velocity)
	probetimer += (delta * 100)
	if probetimer >= probeduration:
		get_tree().call_group("player", "teleport", global_position)
		queue_free()

func faceLeft():
	velocity = Vector2(speed * -1, 0)
