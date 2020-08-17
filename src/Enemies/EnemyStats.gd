extends Node

export var MAX_HEALTH = 1
onready var health = MAX_HEALTH setget set_health

signal no_health

func set_health(val):
	health = val
	if health <=0:
		emit_signal("no_health")
