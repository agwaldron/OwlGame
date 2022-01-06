extends KinematicBody2D

enum {
	IDLE,
	CACTUS,
	FLYDOWN,
	FLYUP,
	WINE # temp
}

const BeePortal = preload("res://src/Enemies/TheWitch/Spells/BeePortal.tscn")
const CactusAttack = preload("res://src/Enemies/TheWitch/Spells/CactusAttack.tscn")
const CactusGuard = preload("res://src/Enemies/TheWitch/Spells/CactusGuard.tscn")
const WineBottle = preload("res://src/Enemies/TheWitch/Spells/WineBottle.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var state
var beespawns = 0
var beevanishes = 0
var beespercycle = 4
var beecooldown = 750
var beetimer
var beepos1 = Vector2(250, 300)
var beepos2 = Vector2(1050, 300)
var attackcooldown = 300
var attacktimer
var maxcactusattacks = 3
var numcactusattacks = 0
var cactusready
var cactusattackheight = 200
var playerpos
var wineready
var groundheight = 700
var flyheight = 400
var flyspeed = 500
var velocity = Vector2.ZERO

var hitflashduration = 8
var hitflashtimer = 0
var hitflashflag = false

func _ready():
	animatedSprite.play("Idle")
	global_position.y = groundheight
	stats.health = 20
	beetimer = beecooldown
	attacktimer = attackcooldown
	state = IDLE
	wineready = false
	cactusready = false

func _process(delta):
	if hitflashflag:
		hit_flash_countdown(delta)
	beeSpawns(delta)
	match state:
		IDLE:
			attacktimer -= (delta * 100)
			if attacktimer <= 0:
				attack()
		CACTUS:
			cactusState()
		FLYDOWN:
			flyDown(delta)
		FLYUP:
			flyUp(delta)
		WINE: # temp
			castingWine(delta)

func attack():
	if wineready:
		get_tree().call_group("player", "cast_ice_platform")
		state = FLYUP
		animatedSprite.play("FlyUp")
		velocity.y = flyspeed * -1
	else:
		state = CACTUS
		animatedSprite.play("Cast")
		animatedSprite.set_frame(0)
		numcactusattacks = 0
		cactusready = false
		castCactusGuard()

func cactusState():
	if cactusready:
		animatedSprite.play("Cast")
		animatedSprite.set_frame(0)
		castCactusAttack()

func flyUp(_delta):
	if global_position.y <= flyheight:
		animatedSprite.play("Idle")
		velocity.y = 0
		castWine()
	else:
		velocity = move_and_slide(velocity)

func flyDown(_delta):
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
			beeportal.z_index = z_index

			beeportal = BeePortal.instance()
			get_parent().add_child(beeportal)
			beeportal.global_position.x = beepos2.x
			beeportal.global_position.y = beepos2.y
			beeportal.z_index = z_index

			beespawns += 2
			beetimer = beecooldown

func castCactusGuard():
	var cactusGuard = CactusGuard.instance()
	get_parent().add_child(cactusGuard)
	cactusGuard.global_position = global_position
	cactusGuard.global_position.x -= cactusGuard.horoffset
	cactusGuard.global_position.y += cactusGuard.vertoffset
	cactusGuard.z_index = z_index

func castCactusAttack():
	var cactusAttack = CactusAttack.instance()
	get_parent().add_child(cactusAttack)
	cactusAttack.playerpos = playerpos
	cactusAttack.global_position.x = playerpos.x
	cactusAttack.global_position.y = cactusattackheight
	cactusready = false

# temp
func castingWine(_delta):
	pass

func castWine():
	animatedSprite.play("Cast")
	animatedSprite.set_frame(0)
	state = WINE

	var wineBottle = WineBottle.instance()
	get_parent().add_child(wineBottle)
	wineBottle.global_position = global_position
	wineBottle.global_position.x -= wineBottle.horoffset
	wineBottle.global_position.y += wineBottle.vertoffset
	wineBottle.z_index = z_index

func cactusSmashed():
	numcactusattacks += 1
	if numcactusattacks < maxcactusattacks:
		cactusready = true
	else:
		get_tree().call_group("cactusguard", "disperse")

func cactusGuardUp():
	cactusready = true

func beeVanish():
	beevanishes += 1
	if beevanishes == beespercycle:
		wineready = true

func cactusFinished():
	state = IDLE
	attacktimer = attackcooldown

func wineFinished():
	state = FLYDOWN
	animatedSprite.play("FlyDown")
	velocity.y = flyspeed
	get_tree().call_group("player", "disperse_ice_platform")

func update_player_location(pos):
	playerpos = pos

func hit_flash_countdown(delta):
	if hitflashtimer <= 0:
		hitflashflag = false
		animatedSprite.material.set_shader_param("white", false)
	else:
		hitflashtimer -= delta * 100

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			hitflashtimer = hitflashduration
			hitflashflag = true
			animatedSprite.material.set_shader_param("white", true)
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
