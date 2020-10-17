extends KinematicBody2D

enum {
	SUMMON,
	STABLE,
	SHATTER
}

onready var animatedSprite = $AnimatedSprite
onready var colShape = $CollisionShape2D

var state
var playercom

func _ready():
	state = SUMMON
	animatedSprite.play("Summon")
	animatedSprite.set_frame(0)
	playercom = false

func shatterPlatform():
	state = SHATTER
	animatedSprite.play("Shatter")
	animatedSprite.set_frame(0)
	colShape.disabled = true

func _on_AnimatedSprite_animation_finished():
	if state == SUMMON:
		state = STABLE
		colShape.disabled = false
		if playercom:
			get_tree().call_group("player", "ice_platform_summoned")
	elif state == SHATTER:
		queue_free()
