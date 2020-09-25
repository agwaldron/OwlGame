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
var horizontalCenter
var summoningTimer
var rngen = RandomNumberGenerator.new()

var obeliskxpos1 = 150
var obeliskxpos2 = 425
var obeliskxpos3 = 700
var obeliskxpos4 = 975

func _ready():
	animatedSprite.play("Idle")
	stats.health = 20
	state = PREP
	horizontalCenter = get_viewport().size.x/2
	summoningTimer = SUMMONING_COOLDOWN
	rngen.randomize()

func _process(delta):
	if state == PREP:
		summoningTimer -= (delta * 100)
		if summoningTimer <= 0:
			animatedSprite.play("Summon")
			state = SUMMONING

func summon():
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
