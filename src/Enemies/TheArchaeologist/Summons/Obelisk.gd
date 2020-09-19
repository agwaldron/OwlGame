extends KinematicBody2D

export var STAND_DURATION = 100

onready var animatedSprite = $AnimatedSprite
onready var baseHitBox = $Base/CollisionShape2D
onready var quarterHitBox = $QuarterPillar/CollisionShape2D
onready var halfHitBox = $HalfPillar/CollisionShape2D
onready var threeFourHitBox = $ThreeFourPillar/CollisionShape2D
onready var pillarHitBox = $FullPillar/CollisionShape2D

var growing
var crumbling
var standing
var crumbleTimer

func _ready():
	animatedSprite.play("Summon")
	animatedSprite.set_frame(0)
	growing = true
	standing = false
	crumbling = false
	crumbleTimer = STAND_DURATION

func _process(delta):
	if standing:
		crumbleTimer -= (delta * 100)
		if crumbleTimer<=0:
			crumble()
			standing = false
			crumbling = true

func crumble():
	animatedSprite.play("Crumble")
	baseHitBox.disabled = true
	pillarHitBox.disabled = true

func _on_AnimatedSprite_frame_changed():
	if growing:
		if animatedSprite.get_frame() == 5:
			quarterHitBox.disabled = false
			get_tree().call_group("camera", "obelisk_growing")
		elif animatedSprite.get_frame() == 8:
			quarterHitBox.disabled = true
			halfHitBox.disabled = false
		elif animatedSprite.get_frame() == 11:
			halfHitBox.disabled = true
			threeFourHitBox.disabled = false
		elif animatedSprite.get_frame() == 13:
			threeFourHitBox.disabled = true
			pillarHitBox.disabled = false

func _on_AnimatedSprite_animation_finished():
	if growing:
		baseHitBox.disabled = false
		growing = false
		animatedSprite.play("Obelisk")
		get_tree().call_group("camera", "obelisk_stop")
		standing = true
	elif crumbling:
		get_tree().call_group("archaeologist", "summon_complete")
		queue_free()
