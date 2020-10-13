extends KinematicBody2D

const BeePortal = preload("res://src/Enemies/TheWitch/Spells/BeePortal.tscn")
const MagicDagger = preload("res://src/Enemies/TheWitch/Spells/MagicDagger.tscn")

onready var animatedSpirte = $AnimatedSprite
onready var stats = $EnemyStats

var beecooldown = 50000
var beetimer
var attackcooldown = 700
var attacktimer
var vertdaggerpos = 100
var hordaggerpos = 900
var playerpos

func _ready():
	stats.health = 20
	beetimer = beecooldown
	attacktimer = attackcooldown

func _process(delta):
	beeSpawns(delta)
	attacktimer -= (delta * 100)
	if attacktimer <= 0:
		attack()

func beeSpawns(delta):
	beetimer -= (delta * 100)
	if beetimer <= 0:
		var beeportal = BeePortal.instance()
		get_parent().add_child(beeportal)
		beeportal.global_position = global_position
		beeportal.global_position.x -= 300
		beeportal.global_position.y -= 300
		beetimer = beecooldown

func attack():
	var magicdagger = MagicDagger.instance()
	get_parent().add_child(magicdagger)
	magicdagger.playerpos = playerpos
	magicdagger.global_position.x = hordaggerpos
	magicdagger.global_position.y = playerpos.y - magicdagger.horoffset

	magicdagger = MagicDagger.instance()
	get_parent().add_child(magicdagger)
	magicdagger.playerpos = playerpos
	magicdagger.isVertical()
	magicdagger.global_position.x = playerpos.x - magicdagger.vertoffset
	magicdagger.global_position.y = vertdaggerpos

	attacktimer = attackcooldown

func updatePlayerLocation(pos):
	playerpos = pos

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
