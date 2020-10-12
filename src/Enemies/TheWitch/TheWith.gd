extends KinematicBody2D

const BeePortal = preload("res://src/Enemies/TheWitch/Spells/BeePortal.tscn")

onready var animatedSpirte = $AnimatedSprite
onready var stats = $EnemyStats

var beeCoolDown = 50000
var beeTimer

func _ready():
	stats.health = 20
	beeTimer = beeCoolDown

func _process(delta):
	beeTimer -= (delta * 100)
	if beeTimer <= 0:
		var beePortal = BeePortal.instance()
		get_parent().add_child(beePortal)
		beePortal.global_position = global_position
		beePortal.global_position.x -= 300
		beePortal.global_position.y -= 300
		beeTimer = beeCoolDown

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
