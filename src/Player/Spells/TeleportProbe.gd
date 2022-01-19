extends KinematicBody2D

var speed = 2500
var velocity = Vector2(speed, 0)
var probeDuration = 10
var probeTimer = 0

func _process(delta):
	velocity = move_and_slide(velocity)
	probeTimer += (delta * 100)
	get_tree().call_group("player", "teleport_move", global_position)
	if probeTimer >= probeDuration:
		get_tree().call_group("player", "teleport_appear", global_position)
		queue_free()

func faceLeft():
	velocity = Vector2(speed * -1, 0)
