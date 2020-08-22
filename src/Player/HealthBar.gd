extends Control

var max_health = 3 setget set_max_health
var health = 3 setget set_health 

onready var heartDisplay = $FullHeartDisplay

func set_max_health(val):
	max_health = val

func set_health(val):
	if val > 0:
		heartDisplay.rect_size.x = health * 64
	else:
		queue_free()
