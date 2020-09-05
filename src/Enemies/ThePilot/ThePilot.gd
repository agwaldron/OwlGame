extends KinematicBody2D

onready var stats = $EnemyStats

func _ready():
	stats.health = 15

func _on_HurtBox_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
