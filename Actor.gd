extends KinematicBody2D
class_name Actor

export var gravity = 3000

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide(velocity)
