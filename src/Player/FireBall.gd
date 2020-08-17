extends KinematicBody2D

export var SPEED = 1000

onready var sprite = $Sprite

var velocity = Vector2(SPEED, 0)

func _process(delta):
	velocity = move_and_slide(velocity)
