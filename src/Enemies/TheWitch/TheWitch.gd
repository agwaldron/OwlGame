extends KinematicBody2D

enum {
	IDLE,
	CACTUS,
	FLY_DOWN,
	FLY_UP,
	WINE # temp
}

const BeePortal = preload("res://src/Enemies/TheWitch/Spells/BeePortal.tscn")
const CactusAttack = preload("res://src/Enemies/TheWitch/Spells/CactusAttack.tscn")
const CactusGuard = preload("res://src/Enemies/TheWitch/Spells/CactusGuard.tscn")
const WineBottle = preload("res://src/Enemies/TheWitch/Spells/WineBottle.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var state
var beeSpawns = 0
var beeVanishes = 0
var beesPerCycle = 4
var beeCoolDown = 750
var beeTimer
var beePosition1 = Vector2(250, 300)
var beePosition2 = Vector2(1050, 300)
var attackCoolDown = 300
var attackTimer
var maxCactusAttacks = 3
var numCactusAttacks = 0
var cactusReady
var cactusAttackHeight = 200
var playerPosition
var wineReady
var groundHeight = 700
var flyHeight = 400
var flySpeed = 500
var velocity = Vector2.ZERO

var hitFlashDuration = 8
var hitFlashTimer = 0
var hitFlashFlag = false

func _ready():
	animatedSprite.play("Idle")
	global_position.y = groundHeight
	stats.health = 20
	beeTimer = beeCoolDown
	attackTimer = attackCoolDown
	state = IDLE
	wineReady = false
	cactusReady = false

func _process(delta):
	if hitFlashFlag:
		hit_flash_countdown(delta)
	bee_spawns(delta)
	match state:
		IDLE:
			attackTimer -= (delta * 100)
			if attackTimer <= 0:
				attack()
		CACTUS:
			cactus_state()
		FLY_DOWN:
			fly_down(delta)
		FLY_UP:
			fly_up(delta)
		WINE: # temp
			casting_wine(delta)

func attack():
	if wineReady:
		get_tree().call_group("player", "cast_ice_platform")
		state = FLY_UP
		animatedSprite.play("FlyUp")
		velocity.y = flySpeed * -1
	else:
		state = CACTUS
		animatedSprite.play("Cast")
		animatedSprite.set_frame(0)
		numCactusAttacks = 0
		cactusReady = false
		cast_cactus_guard()

func cactus_state():
	if cactusReady:
		animatedSprite.play("Cast")
		animatedSprite.set_frame(0)
		cast_cactus_attack()

func fly_up(_delta):
	if global_position.y <= flyHeight:
		animatedSprite.play("Idle")
		velocity.y = 0
		cast_wine()
	else:
		velocity = move_and_slide(velocity)

func fly_down(_delta):
	if global_position.y >= groundHeight:
		wineReady = false
		velocity.y = 0
		state = IDLE
		animatedSprite.play("Idle")
		beeSpawns = 0
		beeVanishes = 0
		attackTimer = attackCoolDown
	else:
		velocity = move_and_slide(velocity)

func bee_spawns(delta):
	if beeSpawns < beesPerCycle:
		beeTimer -= (delta * 100)
		if beeTimer <= 0:
			var beeportal = BeePortal.instance()
			get_parent().add_child(beeportal)
			beeportal.global_position.x = beePosition1.x
			beeportal.global_position.y = beePosition1.y
			beeportal.z_index = z_index

			beeportal = BeePortal.instance()
			get_parent().add_child(beeportal)
			beeportal.global_position.x = beePosition2.x
			beeportal.global_position.y = beePosition2.y
			beeportal.z_index = z_index

			beeSpawns += 2
			beeTimer = beeCoolDown

func cast_cactus_guard():
	var cactusGuard = CactusGuard.instance()
	get_parent().add_child(cactusGuard)
	cactusGuard.global_position = global_position
	cactusGuard.global_position.x -= cactusGuard.horizontalOffset
	cactusGuard.global_position.y += cactusGuard.verticalOffset
	cactusGuard.z_index = z_index

func cast_cactus_attack():
	var cactusAttack = CactusAttack.instance()
	get_parent().add_child(cactusAttack)
	cactusAttack.playerPosition = playerPosition
	cactusAttack.global_position.x = playerPosition.x
	cactusAttack.global_position.y = cactusAttackHeight
	cactusReady = false

# temp
func casting_wine(_delta):
	pass

func cast_wine():
	animatedSprite.play("Cast")
	animatedSprite.set_frame(0)
	state = WINE

	var wineBottle = WineBottle.instance()
	get_parent().add_child(wineBottle)
	wineBottle.global_position = global_position
	wineBottle.global_position.x -= wineBottle.horizontalOffset
	wineBottle.global_position.y += wineBottle.verticalOffset
	wineBottle.z_index = z_index

func cactus_smashed():
	numCactusAttacks += 1
	if numCactusAttacks < maxCactusAttacks:
		cactusReady = true
	else:
		get_tree().call_group("cactusguard", "disperse")

func cactus_guard_up():
	cactusReady = true

func bee_vanish():
	beeVanishes += 1
	if beeVanishes == beesPerCycle:
		wineReady = true

func cactus_finished():
	state = IDLE
	attackTimer = attackCoolDown

func wine_finished():
	state = FLY_DOWN
	animatedSprite.play("FlyDown")
	velocity.y = flySpeed
	get_tree().call_group("player", "disperse_ice_platform")

func update_player_location(pos):
	playerPosition = pos

func hit_flash_countdown(delta):
	if hitFlashTimer <= 0:
		hitFlashFlag = false
		animatedSprite.material.set_shader_param("white", false)
	else:
		hitFlashTimer -= delta * 100

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			hitFlashTimer = hitFlashDuration
			hitFlashFlag = true
			animatedSprite.material.set_shader_param("white", true)
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
