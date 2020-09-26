extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

func _ready():
	stats.health = 15
	animatedSprite.play("Idle")

func _on_TheDude_area_entered(area):
	var area_groups = area.get_groups()
	for x in area_groups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
