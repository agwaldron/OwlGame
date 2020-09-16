extends KinematicBody2D

export var HORIZONTAL_SPEED = -600
export var VERTICAL_SPEED = -400

onready var sprite_horizontal_offset = 35

var max_height = 500
var min_height = 660
var velocity = Vector2.ZERO

func _process(delta):
	if velocity.y < 0 and global_position.y < max_height:
		velocity.y = velocity.y * -1
	elif velocity.y > 0 and global_position.y > min_height:
		velocity.y = velocity.y * -1

	velocity = move_and_slide(velocity)

func _on_HitBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "BlockingSpell":
			queue_free()

func _on_HitBox_body_entered(body):
	queue_free()
