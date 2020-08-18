extends KinematicBody2D

onready var stats = $EnemyStats

func _ready():
	stats.health = 2

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
