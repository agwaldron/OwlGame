extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var baseHitBox = $Base/CollisionShape2D
onready var pillarHitBox = $Pillar/CollisionShape2D

func crumble():
	animatedSprite.play("Crumble")
	baseHitBox.disabled = true
	pillarHitBox.disabled = true
