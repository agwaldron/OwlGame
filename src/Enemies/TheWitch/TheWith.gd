extends KinematicBody2D

enum {
	IDLE,
	CAST
}

const BeePortal = preload("res://src/Enemies/TheWitch/Spells/BeePortal.tscn")
const MagicDagger = preload("res://src/Enemies/TheWitch/Spells/MagicDagger.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var state
var beecooldown = 1000
var beetimer
var beepos1 = Vector2(350, 125)
var beepos2 = Vector2(950, 125)
var attackcooldown = 600
var attacktimer
var vertdaggerpos = 100
var hordaggerpos = 900
var playerpos

func _ready():
	stats.health = 20
	beetimer = beecooldown
	attacktimer = attackcooldown
	state = IDLE

func _process(delta):
	beeSpawns(delta)
	if state == IDLE:
		attacktimer -= (delta * 100)
		if attacktimer <= 0:
			cast()


func beeSpawns(delta):
	beetimer -= (delta * 100)
	if beetimer <= 0:
		var beeportal = BeePortal.instance()
		get_parent().add_child(beeportal)
		beeportal.global_position.x = beepos1.x
		beeportal.global_position.y = beepos1.y

		beeportal = BeePortal.instance()
		get_parent().add_child(beeportal)
		beeportal.global_position.x = beepos2.x
		beeportal.global_position.y = beepos2.y

		beetimer = beecooldown

func cast():
	state = CAST
	animatedSprite.play("Cast")

func castDagger():
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

func spellFinished():
	animatedSprite.playing = true

func updatePlayerLocation(pos):
	playerpos = pos

func _on_AnimatedSprite_frame_changed():
	if state == CAST and animatedSprite.get_frame() == 3:
		castDagger()
		animatedSprite.playing = false
		attacktimer = attackcooldown

func _on_AnimatedSprite_animation_finished():
	if state == CAST:
		state = IDLE
		animatedSprite.play("Idle")

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
