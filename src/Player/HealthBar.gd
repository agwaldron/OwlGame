extends Control

var health = 3

onready var heartDisplay = $FullHeartDisplay

func set_health(val):
	health = val
	if val > 0:
		heartDisplay.rect_size.x = health * 64
	else:
		queue_free()
