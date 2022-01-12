extends KinematicBody2D

export var HORIZONTAL_SPEED = -600
export var VERTICAL_SPEED = -400

onready var spriteHorizontalOffset = 35

var maxHeight = 500
var minHeight = 660
var velocity = Vector2.ZERO

func _process(_delta):
	if velocity.y < 0 and global_position.y < maxHeight:
		velocity.y = velocity.y * -1
	elif velocity.y > 0 and global_position.y > minHeight:
		velocity.y = velocity.y * -1

	velocity = move_and_slide(velocity)

func _on_HitBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "BlockingSpell":
			queue_free()

func _on_HitBox_body_entered(_body):
	queue_free()
