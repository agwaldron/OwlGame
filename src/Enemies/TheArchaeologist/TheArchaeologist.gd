extends KinematicBody2D

export var SUMMONING_COOLDOWN = 75

enum {
	IDLE,
	PREP,
	SUMMONING
}

const Obelisk = preload("res://src/Enemies/TheArchaeologist/Summons/Obelisk.tscn")
const Sandnado = preload("res://src/Enemies/TheArchaeologist/Summons/Sandnado.tscn")
const SummoningCircle = preload("res://src/Enemies/TheArchaeologist/Summons/SummoningCircle.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var state
var width
var horizontalCenter
var summoningTimer
var rngen = RandomNumberGenerator.new()

func _ready():
	animatedSprite.play("Idle")
	stats.health = 15
	state = PREP
	width = get_viewport().size.x
	horizontalCenter = width/2
	summoningTimer = SUMMONING_COOLDOWN
	rngen.randomize()

func _process(delta):
	if state == PREP:
		summoningTimer -= (delta * 100)
		if summoningTimer <= 0:
			animatedSprite.play("Summon")
			state = SUMMONING

func summon():
	animatedSprite.play("Idle")
	state = IDLE
	var randNum = rngen.randi_range(0, 2)
	match randNum:
		0:
			summon_mummies()
		1:
			summon_obelisks()
		2:
			summon_sandnado()

func summon_mummies():
	var circle = SummoningCircle.instance()
	get_parent().add_child(circle)
	circle.global_position = global_position
	circle.global_position.x = rngen.randf_range(horizontalCenter/2, horizontalCenter)

	circle = SummoningCircle.instance()
	get_parent().add_child(circle)
	circle.global_position = global_position
	circle.global_position.x = rngen.randf_range(horizontalCenter, (horizontalCenter*3)/4)

func summon_obelisks():
	var obelisk = Obelisk.instance()
	get_parent().add_child(obelisk)
	obelisk.global_position = global_position
	obelisk.global_position.x = width/8

	obelisk = Obelisk.instance()
	get_parent().add_child(obelisk)
	obelisk.global_position = global_position
	obelisk.global_position.x = (width*3)/8

	obelisk = Obelisk.instance()
	get_parent().add_child(obelisk)
	obelisk.global_position = global_position
	obelisk.global_position.x = (width*5)/8

	obelisk = Obelisk.instance()
	get_parent().add_child(obelisk)
	obelisk.global_position = global_position
	obelisk.global_position.x = (width*6)/8

func summon_sandnado():
	var sandnado = Sandnado.instance()
	get_parent().add_child(sandnado)
	sandnado.global_position = global_position
	sandnado.global_position.x -= sandnado.sprite_horizontal_offset

func summon_complete():
	state = PREP
	summoningTimer = SUMMONING_COOLDOWN

func _on_AnimatedSprite_animation_finished():
	if state == SUMMONING:
		summon()

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
