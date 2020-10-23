extends KinematicBody2D

export var SUMMONING_COOLDOWN = 75

enum {
	IDLE,
	PREP,
	SUMMONING
}

const Cobra = preload("res://src/Enemies/TheArchaeologist/Summons/Cobra.tscn")
const Obelisk = preload("res://src/Enemies/TheArchaeologist/Summons/Obelisk.tscn")
const SummoningCircle = preload("res://src/Enemies/TheArchaeologist/Summons/SummoningCircle.tscn")

onready var animatedSprite = $AnimatedSprite
onready var stats = $EnemyStats

var state
var horizontalCenter
var summontracker
var summoningTimer

var obeliskxpos1 = 150
var obeliskxpos2 = 425
var obeliskxpos3 = 700
var obeliskxpos4 = 975

func _ready():
	animatedSprite.play("Idle")
	stats.health = 20
	state = PREP
	horizontalCenter = get_viewport().size.x/2
	summontracker = 1
	summoningTimer = SUMMONING_COOLDOWN

func _process(delta):
	if state == PREP:
		summoningTimer -= (delta * 100)
		if summoningTimer <= 0:
			animatedSprite.play("Summon")
			state = SUMMONING

func summon():
	if summontracker % 2 == 0:
		summon_mummies()
	elif summontracker == 1:
		summon_obelisks()
	elif summontracker == 3:
		summon_cobra()

	summontracker = (summontracker + 1) % 4

func summon_cobra():
	var cobra = Cobra.instance()
	get_parent().add_child(cobra)
	cobra.global_position = global_position
	cobra.global_position.x -= cobra.horizontaloffset

func summon_mummies():
	var circle = SummoningCircle.instance()
	get_parent().add_child(circle)
	circle.global_position = global_position
	circle.global_position.x = rand_range(obeliskxpos1, obeliskxpos2)

	circle = SummoningCircle.instance()
	get_parent().add_child(circle)
	circle.global_position = global_position
	circle.global_position.x = rand_range(obeliskxpos3, obeliskxpos4)

func summon_obelisks():
	var obelisk = Obelisk.instance()
	get_parent().add_child(obelisk)
	obelisk.global_position = global_position
	obelisk.global_position.x = obeliskxpos1

	obelisk = Obelisk.instance()
	get_parent().add_child(obelisk)
	obelisk.global_position = global_position
	obelisk.global_position.x = obeliskxpos2

	obelisk = Obelisk.instance()
	get_parent().add_child(obelisk)
	obelisk.global_position = global_position
	obelisk.global_position.x = obeliskxpos3

	obelisk = Obelisk.instance()
	get_parent().add_child(obelisk)
	obelisk.global_position = global_position
	obelisk.global_position.x = obeliskxpos4

func summon_complete():
	state = PREP
	summoningTimer = SUMMONING_COOLDOWN

func _on_AnimatedSprite_animation_finished():
	if state == SUMMONING:
		animatedSprite.play("Idle")
		state = IDLE

func _on_AnimatedSprite_frame_changed():
	if state == SUMMONING and animatedSprite.get_frame() == 9:
		summon()

func _on_HurtBox_area_entered(area):
	var areaGroups = area.get_groups()
	for x in areaGroups:
		if x == "PlayerSpell":
			stats.health -= area.damage

func _on_EnemyStats_no_health():
	queue_free()
