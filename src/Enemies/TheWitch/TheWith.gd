extends KinematicBody2D

enum {
	IDLE,
	CAST,
	FLYDOWN,
	FLYUP
}

const BeePortal = preload("res://src/Enemies/TheWitch/Spells/BeePortal.tscn")
const MagicDagger = preload("res://src/Enemies/TheWitch/Spells/MagicDagger.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var state
var beespawns = 0
var beevanishes = 0
var beespercycle = 4
var beecooldown = 900
var beetimer
var beepos1 = Vector2(350, 125)
var beepos2 = Vector2(950, 125)
var attackcooldown = 600
var attacktimer
var vertdaggerpos = 100
var hordaggerpos = 900
var playerpos
var wineready
var groundheight = 700
var flyheight = 400
var flyspeed = 500
var velocity = Vector2.ZERO

func _ready():
	animatedSprite.play("Idle")
	global_position.y = groundheight
	stats.health = 20
	beetimer = beecooldown
	attacktimer = attackcooldown
	state = IDLE
	wineready = false

func _process(delta):
	beeSpawns(delta)
	match state:
		IDLE:
			attacktimer -= (delta * 100)
			if attacktimer <= 0:
				attack()
		CAST:
			pass
		FLYDOWN:
			flyDown(delta)
		FLYUP:
			flyUp(delta)

func attack():
	if wineready:
		state = FLYUP
		animatedSprite.play("FlyUp")
		velocity.y = flyspeed * -1
	else:
		state = CAST
		animatedSprite.play("Cast")
		animatedSprite.set_frame(0)
		castDagger()

func flyUp(delta):
	if global_position.y <= flyheight:
		state = CAST
		animatedSprite.play("Idle")
		velocity.y = 0
		castWine()
	else:
		velocity = move_and_slide(velocity)

func flyDown(delta):
	if global_position.y >= groundheight:
		wineready = false
		velocity.y = 0
		state = IDLE
		animatedSprite.play("Idle")
		beespawns = 0
		beevanishes = 0
		attacktimer = attackcooldown
	else:
		velocity = move_and_slide(velocity)

func beeSpawns(delta):
	if beespawns < beespercycle:
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

			beespawns += 2
			beetimer = beecooldown


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

func castWine():
	print("wine")
	spellFinished()

func beeVanish():
	beevanishes += 1
	if beevanishes == beespercycle:
		wineready = true

func spellFinished():
	if wineready:
		state = FLYDOWN
		animatedSprite.play("FlyDown")
		velocity.y = flyspeed
	else:
		state = IDLE
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
