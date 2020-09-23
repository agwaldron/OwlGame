extends KinematicBody2D

export var SPEED = 1000

var velocity

func _ready():
	velocity = Vector2(SPEED, 0)

func _process(delta):
	velocity = move_and_slide(velocity)

func _on_HitBox_area_entered(area):
	queue_free()

func _on_HitBox_body_entered(body):
	queue_free()
