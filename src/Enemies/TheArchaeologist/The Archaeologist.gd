extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

func _ready():
	stats.health = 15

func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
