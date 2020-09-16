extends KinematicBody2D

export var SPEED = 800

onready var sprite_vertical_offset = 75
onready var sprite_horizontal_offset = 35

var velocity = Vector2(SPEED, 0)

func _process(delta):
	velocity = move_and_slide(velocity)

func _on_HitBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "BlockingSpell":
			queue_free()

func _on_HitBox_body_entered(body):
	queue_free()
