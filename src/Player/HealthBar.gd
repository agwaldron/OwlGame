extends Control

var health = 3

onready var fullHeartDisplay = $FullHeartDisplay
onready var emptyHeartDisplay = $EmptyHeartDisplay

func set_max(val):
	health = val
	fullHeartDisplay.rect_size.x = health * 64
	emptyHeartDisplay.rect_size.x = health * 64

func set_health(val):
	health = val
	if val > 0:
		fullHeartDisplay.rect_size.x = health * 64
	else:
		queue_free()
