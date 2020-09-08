extends KinematicBody2D

export var SPEED = 800

onready var sprite = $Sprite
onready var sprite_vertical_offset = 40
onready var sprite_horizontal_offset = 30

var velocity = Vector2.ZERO

func _process(delta):
	velocity = move_and_slide(velocity)

func fire():
	velocity = Vector2(SPEED, 0)

func _on_HitBox_body_entered(body):
	queue_free()
