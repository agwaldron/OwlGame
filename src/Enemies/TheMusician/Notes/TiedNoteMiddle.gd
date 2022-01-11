extends KinematicBody2D

export var SPEED = 800

onready var spriteVerticalOffset = 75
onready var spriteHorizontalOffset = 35

var velocity = Vector2(SPEED, 0)

func _process(_delta):
	velocity = move_and_slide(velocity)

func _on_HitBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "BlockingSpell":
			queue_free()

func _on_HitBox_body_entered(_body):
	queue_free()
