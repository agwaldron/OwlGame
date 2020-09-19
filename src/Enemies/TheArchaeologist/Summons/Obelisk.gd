extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var baseHitBox = $Base/CollisionShape2D
onready var quarterHitBox = $QuarterPillar/CollisionShape2D
onready var halfHitBox = $HalfPillar/CollisionShape2D
onready var threeFourHitBox = $ThreeFourPillar/CollisionShape2D
onready var pillarHitBox = $FullPillar/CollisionShape2D

var growing
var crumbling

func _ready():
	animatedSprite.play("Summon")
	animatedSprite.set_frame(0)
	growing = true
	crumbling = false

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
	elif crumbling:
		queue_free()
